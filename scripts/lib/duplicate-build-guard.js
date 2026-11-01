'use strict';

/**
 * Decision core of the duplicate and reuse check.
 *
 * Both intake paths run the same rule: `.github/workflows/auto-review-build.yml`
 * on issue open and `.github/workflows/issue-build.yml` when the repository
 * owner labels a request. They each own the REST plumbing, but the fingerprint,
 * the comment shapes and the artifact test live here so the two cannot drift.
 *
 * The function is pure: callers pass in parsed issues, runs and artifacts, and
 * get back the run to reuse or null. `.github/workflows/tests.yml` runs
 * `scripts/test-duplicate-build-guard.js`, which drives this module.
 */

const crypto = require('crypto');

const FINGERPRINT_PATTERN = /<!-- fanchmwrt-build fingerprint=([a-f0-9]{64}) -->/;
const RUN_PATTERN = /\/actions\/runs\/(\d+)/;

/**
 * Stable identity of a build target. The order is part of the contract: a
 * completed build is recognised by recomputing this hash from the request.
 */
function identity(commit, architecture, target, subtarget, profile) {
  return [commit, architecture, target, subtarget, profile].join('\n');
}

function fingerprintOf(fields) {
  return crypto.createHash('sha256').update(identity(...fields)).digest('hex');
}

/** 30 day reuse window, as an ISO instant. */
function reuseCutoff(now) {
  return new Date(now - 30 * 24 * 60 * 60 * 1000).toISOString();
}

/**
 * Mirror of the force-build bypass. Both workflows must consult the live label
 * list: `github.event.issue.labels` on an `issues: labeled` event is a snapshot
 * from before the label was applied and never contains the new label.
 */
function shouldRunGuard(liveLabels) {
  return !liveLabels.includes('force-build');
}

/**
 * Collect the bot comments written against `approved-build` issues.
 *
 * `world.issues` is a Map of issue number to `{ updated_at, comments }`, and a
 * comment is `{ user, created_at, body }`. The candidate issue itself is never a
 * source: its own success comment describes this very request.
 */
function collectBotComments(world, { candidateIssueNumber, cutoff }) {
  const comments = [];
  for (const [number, issue] of world.issues) {
    if (number === candidateIssueNumber) continue;
    if (issue.updated_at < cutoff) continue;
    for (const comment of issue.comments) {
      if (comment.user !== 'github-actions[bot]') continue;
      if (comment.created_at < cutoff) continue;
      comments.push({ ...comment, issue_number: number });
    }
  }
  return comments;
}

/**
 * Comments that may describe a reusable build, newest first.
 *
 * A comment qualifies when its fingerprint marker matches the requested target.
 * Comments written before the marker existed are accepted only when no marked
 * comment claims the same run -- otherwise an old comment could vouch for a run
 * that has since been described precisely.
 */
function candidatesFor(fields, comments) {
  const fingerprint = fingerprintOf(fields);
  const [, architecture, target, subtarget, profile] = fields;

  const fingerprintedRuns = new Set();
  for (const comment of comments) {
    const runMatch = (comment.body || '').match(RUN_PATTERN);
    if (runMatch && FINGERPRINT_PATTERN.test(comment.body || '')) {
      fingerprintedRuns.add(runMatch[1]);
    }
  }

  // The legacy footer records the requested ref, which the fingerprint does not
  // carry -- two refs can resolve to the same commit -- so the caller supplies
  // the ref it expects and the prose has to agree with it.
  const legacyFooter = (body, upstreamRef) =>
    body.includes(`- 上游版本：\`${upstreamRef}\``) &&
    body.includes(`- 架构：\`${architecture}\``) &&
    body.includes(`- 目标：\`${target}/${subtarget}/${profile}\``);

  const candidates = [];
  for (const comment of comments) {
    const body = comment.body || '';
    const runMatch = body.match(RUN_PATTERN);
    if (!runMatch) continue;
    const marker = body.match(FINGERPRINT_PATTERN);
    const exact = Boolean(marker) && marker[1] === fingerprint;
    const legacy = !marker && !fingerprintedRuns.has(runMatch[1]);
    if (exact || legacy) {
      candidates.push({
        run_id: Number(runMatch[1]),
        issue_number: comment.issue_number,
        created_at: comment.created_at,
        // A legacy comment still has to name the same target, and it does so in
        // prose rather than in a hash; the caller supplies the ref to compare.
        matches: exact,
        body,
      });
    }
  }
  candidates.sort((left, right) => right.created_at.localeCompare(left.created_at));
  return { candidates, legacyFooter };
}

/**
 * First candidate whose run succeeded and still owns a downloadable artifact.
 *
 * A 404 from the runs API is treated as "not this one" and skipped: the run may
 * have been deleted by retention while its comment stayed behind.
 */
function findDuplicate({ current, candidate, world, cutoff, upstreamRef }) {
  const comments = collectBotComments(world, {
    candidateIssueNumber: candidate.issueNumber,
    cutoff,
  });
  const { candidates, legacyFooter } = candidatesFor(current, comments);

  for (const entry of candidates) {
    if (!entry.matches && !legacyFooter(entry.body, upstreamRef)) continue;
    const run = world.runs.get(String(entry.run_id));
    if (!run || run.missing) continue;
    if (run.conclusion !== 'success') continue;
    const artifacts = world.artifacts.get(String(entry.run_id)) || [];
    if (!artifacts.some(artifact => !artifact.expired)) continue;
    return { runId: String(entry.run_id), issueNumber: entry.issue_number };
  }
  return null;
}

/**
 * Candidate comments for one request, taken from a world of issues.
 *
 * `plan` is what a workflow calls before resolving any run: it filters on the
 * window, skips the requesting issue and returns the comment shapes in newest
 * first order. Resolve `plan.candidates[i].run_id` next, then call
 * `decide`/`findDuplicate` with the same world.
 */
function planFor(fields, { world, candidateIssueNumber, cutoff }) {
  const comments = collectBotComments(world, { candidateIssueNumber, cutoff });
  return candidatesFor(fields, comments);
}

module.exports = {
  FINGERPRINT_PATTERN,
  RUN_PATTERN,
  candidatesFor,
  findDuplicate,
  planFor,
  fingerprintOf,
  identity,
  reuseCutoff,
  shouldRunGuard,
};
