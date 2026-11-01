#!/usr/bin/env node
/**
 * Regression suite for scripts/lib/duplicate-build-guard.js.
 *
 * The module is the real decision core used by auto-review-build.yml and
 * issue-build.yml; this file only supplies recorded REST payloads for it, so a
 * change to the workflow's rules has to change the module and will show up
 * here. The slot-accounting cases at the end keep the controller's regexes in
 * step with the comment shapes the workflows post.
 *
 * Usage: node scripts/test-duplicate-build-guard.js
 */

'use strict';

const assert = require('assert');
const {
  findDuplicate,
  fingerprintOf,
  reuseCutoff,
  shouldRunGuard,
} = require('./lib/duplicate-build-guard.js');

const NOW = Date.parse('2026-11-01T12:00:00Z');
const CUTOFF = new Date(NOW - 30 * 24 * 60 * 60 * 1000).toISOString();
const FRESH = '2026-11-01T10:00:00Z';
const STALE = '2026-09-01T00:00:00Z';
const COMMIT = 'd1e153c1d64637115fdf74a71ad0ffc4144f0a72';

const x86 = [COMMIT, 'x86', 'x86', '64', 'generic', 'fanchmwrt-25.12.4'];
const e20c = ['7c2f32b', 'arm', 'rockchip', 'armv8', 'radxa_e20c', 'fanchmwrt-25.12.4'];

const cases = [];
function test(name, fn) {
  cases.push({ name, fn });
}

test('rejects a repeat of a successful fingerprinted build (#9 vs #22)', () => {
  const world = {
    issues: new Map([[22, {
      updated_at: FRESH,
      comments: [{
        user: 'github-actions[bot]',
        created_at: '2026-11-01T10:20:45Z',
        body: `<!-- fanchmwrt-build fingerprint=${fingerprintOf(x86)} -->\n` +
          '固件构建成功，产物可从本次 Actions 运行中下载.\n\n' +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/41291164081)'
      }]
    }]]),
    runs: new Map([['41291164081', { conclusion: 'success' }]]),
    artifacts: new Map([['41291164081', [{ expired: false }]]])
  };
  const hit = findDuplicate({
    current: x86,
    candidate: { issueNumber: 9 },
    world,
    cutoff: CUTOFF,
    upstreamRef: x86[5]
  });
  assert.ok(hit, 'expected the earlier x86 build to be reused');
  assert.strictEqual(hit.runId, '41291164081');
});

test('allows the build when the earlier artifact has expired', () => {
  const world = {
    issues: new Map([[22, {
      updated_at: FRESH,
      comments: [{
        user: 'github-actions[bot]',
        created_at: '2026-11-01T10:20:45Z',
        body: `<!-- fanchmwrt-build fingerprint=${fingerprintOf(x86)} -->\n` +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/41291164081)'
      }]
    }]]),
    runs: new Map([['41291164081', { conclusion: 'success' }]]),
    artifacts: new Map([['41291164081', [{ expired: true }]]])
  };
  assert.strictEqual(
    findDuplicate({ current: x86, candidate: { issueNumber: 9 }, world, cutoff: CUTOFF, upstreamRef: x86[5] }),
    null
  );
});

test('allows the build when the earlier run failed', () => {
  const world = {
    issues: new Map([[22, {
      updated_at: FRESH,
      comments: [{
        user: 'github-actions[bot]',
        created_at: '2026-11-01T10:20:45Z',
        body: `<!-- fanchmwrt-build fingerprint=${fingerprintOf(x86)} -->\n` +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/41291164081)'
      }]
    }]]),
    runs: new Map([['41291164081', { conclusion: 'failure' }]]),
    artifacts: new Map([['41291164081', [{ expired: false }]]])
  };
  assert.strictEqual(
    findDuplicate({ current: x86, candidate: { issueNumber: 9 }, world, cutoff: CUTOFF, upstreamRef: x86[5] }),
    null
  );
});

test('does not reuse a build of a different target', () => {
  const world = {
    issues: new Map([[22, {
      updated_at: FRESH,
      comments: [{
        user: 'github-actions[bot]',
        created_at: '2026-11-01T10:20:45Z',
        body: `<!-- fanchmwrt-build fingerprint=${fingerprintOf(x86)} -->\n` +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/41291164081)'
      }]
    }]]),
    runs: new Map([['41291164081', { conclusion: 'success' }]]),
    artifacts: new Map([['41291164081', [{ expired: false }]]])
  };
  assert.strictEqual(
    findDuplicate({ current: e20c, candidate: { issueNumber: 17 }, world, cutoff: CUTOFF, upstreamRef: e20c[5] }),
    null
  );
});

test('ignores builds older than the reuse window', () => {
  const world = {
    issues: new Map([[21, {
      updated_at: STALE,
      comments: [{
        user: 'github-actions[bot]',
        created_at: STALE,
        body: `<!-- fanchmwrt-build fingerprint=${fingerprintOf(x86)} -->\n` +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/38000000000)'
      }]
    }]]),
    runs: new Map([['38000000000', { conclusion: 'success' }]]),
    artifacts: new Map([['38000000000', [{ expired: false }]]])
  };
  assert.strictEqual(
    findDuplicate({ current: x86, candidate: { issueNumber: 9 }, world, cutoff: CUTOFF, upstreamRef: x86[5] }),
    null
  );
});

test('never treats its own issue as a duplicate source', () => {
  const world = {
    issues: new Map([[9, {
      updated_at: FRESH,
      comments: [{
        user: 'github-actions[bot]',
        created_at: FRESH,
        body: `<!-- fanchmwrt-build fingerprint=${fingerprintOf(x86)} -->\n` +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/41291164081)'
      }]
    }]]),
    runs: new Map([['41291164081', { conclusion: 'success' }]]),
    artifacts: new Map([['41291164081', [{ expired: false }]]])
  };
  assert.strictEqual(
    findDuplicate({ current: x86, candidate: { issueNumber: 9 }, world, cutoff: CUTOFF, upstreamRef: x86[5] }),
    null
  );
});

test('still honours legacy comments without a fingerprint marker', () => {
  const world = {
    issues: new Map([[3, {
      updated_at: FRESH,
      comments: [{
        user: 'github-actions[bot]',
        created_at: FRESH,
        body: '固件构建成功。\n\n' +
          `- 上游版本：\`${x86[5]}\`\n` +
          `- 架构：\`${x86[1]}\`\n` +
          `- 目标：\`${x86[2]}/${x86[3]}/${x86[4]}\`\n` +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/37000000000)'
      }]
    }]]),
    runs: new Map([['37000000000', { conclusion: 'success' }]]),
    artifacts: new Map([['37000000000', [{ expired: false }]]])
  };
  const hit = findDuplicate({
    current: x86,
    candidate: { issueNumber: 9 },
    world,
    cutoff: CUTOFF,
    upstreamRef: x86[5]
  });
  assert.ok(hit, 'legacy comment should still be reused');
  assert.strictEqual(hit.runId, '37000000000');
});

test('force-build bypasses the check, read from live labels not the event snapshot', () => {
  // Regression: the first version tested `github.event.issue.labels`, which on an
  // `issues: labeled` event is the snapshot taken before the label was applied.
  // It never saw `force-build`, so the guarded step was silently skipped.
  const world = {
    issues: new Map([[15, {
      updated_at: FRESH,
      comments: [{
        user: 'github-actions[bot]',
        created_at: FRESH,
        body: `<!-- fanchmwrt-build fingerprint=${fingerprintOf(e20c)} -->\n` +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/41291703413)'
      }]
    }]]),
    runs: new Map([['41291703413', { conclusion: 'success' }]]),
    artifacts: new Map([['41291703413', [{ expired: false }]]])
  };
  const eventSnapshot = ['build-firmware', 'approved-build'];
  const liveLabels = ['build-firmware', 'approved-build', 'force-build'];

  assert.strictEqual(
    shouldRunGuard(eventSnapshot),
    true,
    'the event snapshot lacks force-build, so the guard would run and compile again'
  );
  assert.strictEqual(
    findDuplicate({ current: e20c, candidate: { issueNumber: 17 }, world, cutoff: CUTOFF, upstreamRef: e20c[5] }) !== null,
    true,
    'without force-build the earlier build must be reused'
  );
  assert.strictEqual(
    shouldRunGuard(liveLabels),
    false,
    'force-build read from live labels must bypass the guard'
  );
});

test('skips a run the retention policy already deleted', () => {
  // The bot comment outlives the run it links; a 404 from the runs API must be
  // "not this one", not a crash that fails the whole request.
  const world = {
    issues: new Map([[22, {
      updated_at: FRESH,
      comments: [{
        user: 'github-actions[bot]',
        created_at: FRESH,
        body: `<!-- fanchmwrt-build fingerprint=${fingerprintOf(x86)} -->\n` +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/41291164081)'
      }, {
        user: 'github-actions[bot]',
        created_at: '2026-11-01T11:00:00Z',
        body: `<!-- fanchmwrt-build fingerprint=${fingerprintOf(x86)} -->\n` +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/41291164099)'
      }]
    }]]),
    runs: new Map([
      ['41291164081', { missing: true }],
      ['41291164099', { conclusion: 'success' }]
    ]),
    artifacts: new Map([['41291164099', [{ expired: false }]]])
  };
  const hit = findDuplicate({ current: x86, candidate: { issueNumber: 9 }, world, cutoff: CUTOFF, upstreamRef: x86[5] });
  assert.ok(hit, 'the surviving run must still be found');
  assert.strictEqual(hit.runId, '41291164099');
});

test('rejects a legacy comment that names a different upstream ref', () => {
  // The fingerprint covers the commit but not the ref, so a legacy footer is
  // compared against the requested ref as well.
  const world = {
    issues: new Map([[3, {
      updated_at: FRESH,
      comments: [{
        user: 'github-actions[bot]',
        created_at: FRESH,
        body: '固件构建成功。\n\n' +
          '- 上游版本：`v25.12.5`\n' +
          `- 架构：\`${x86[1]}\`\n` +
          `- 目标：\`${x86[2]}/${x86[3]}/${x86[4]}\`\n` +
          '[查看 Actions 运行](https://github.com/o/r/actions/runs/37000000000)'
      }]
    }]]),
    runs: new Map([['37000000000', { conclusion: 'success' }]]),
    artifacts: new Map([['37000000000', [{ expired: false }]]])
  };
  assert.strictEqual(
    findDuplicate({ current: x86, candidate: { issueNumber: 9 }, world, cutoff: CUTOFF, upstreamRef: x86[5] }),
    null
  );
});

// ---------------------------------------------------------------------------
// queue-controller.yml slot accounting.  These mirror the regexes and the
// counting rules of "Promote or defer queued requests", so a comment shape that
// makes the controller read the wrong run is caught here instead of by a queue
// that silently stops promoting.
// ---------------------------------------------------------------------------

const CONTROLLER_RUN_PATTERN = /\[查看 (?:本次 )?Actions 运行\]\(\S*?\/actions\/runs\/(\d+)\)/;
const APPROVAL_PATTERN = /<!-- fanchmwrt-auto-approved date=(\d{4}-\d{2}-\d{2}) requester=([A-Za-z0-9-]+) -->/;
const RELEASE_PATTERN = /<!-- fanchmwrt-auto-slot-released run=(\d+) -->/;
const TODAY = '2026-11-01';
const SERVER = 'https://github.com/o/r';

function approvedRunOf(body) {
  const approval = body.match(APPROVAL_PATTERN);
  const run = body.match(CONTROLLER_RUN_PATTERN);
  if (approval?.[1] !== TODAY || !run) return null;
  return { runId: run[1], requester: approval[2] };
}

test('counts the run the approval footer links, not an older build link', () => {
  const body = [
    '检测到过去 30 天内已有相同设备和上游提交的成功构建。',
    '',
    '- [查看原申请 #3](https://github.com/o/r/issues/3)',
    `- [下载之前的构建产物](${SERVER}/actions/runs/900)`,
    '',
    `[查看本次 Actions 运行](${SERVER}/actions/runs/444)`
  ].join('\n');
  // A reusable-build comment carries no approval marker, so it never counts --
  // and if an approval footer is appended later its own link wins.
  assert.strictEqual(approvedRunOf(body), null, 'no approval marker means no slot');

  const withApproval = body + `\n\n<!-- fanchmwrt-auto-approved date=${TODAY} requester=alice -->\n\n` +
    `- [查看 Actions 运行](${SERVER}/actions/runs/444)`;
  const counted = approvedRunOf(withApproval);
  assert.ok(counted, 'an approval comment must be counted');
  assert.strictEqual(counted.runId, '444', 'the footer link must win over the stale build link');
  assert.strictEqual(counted.requester, 'alice');
});

test('counts a queued-build approval footer', () => {
  const body = `<!-- fanchmwrt-auto-approved date=${TODAY} requester=bob -->\n` +
    '等待队列已有名额释放，Bot 已重新校验参数并开始编译。\n\n' +
    `- [查看 Actions 运行](${SERVER}/actions/runs/111)`;
  assert.deepStrictEqual(approvedRunOf(body), { runId: '111', requester: 'bob' });
});

test('ignores a review comment that links a run but never approved it', () => {
  const body = '参数和重复构建检查已通过，Bot 正在按申请顺序分配自动构建名额。\n\n' +
    `[查看审核运行](${SERVER}/actions/runs/555)`;
  assert.strictEqual(approvedRunOf(body), null, 'a review run must not consume a slot');
});

test('reads the slot-release marker regardless of the label state', () => {
  const body = `<!-- fanchmwrt-auto-slot-released run=777 -->\n` +
    '队列中的固件构建失败，自动构建额度已经释放。';
  assert.strictEqual(body.match(RELEASE_PATTERN)?.[1], '777');
});

let failures = 0;
for (const { name, fn } of cases) {
  try {
    fn();
    console.log(`ok   ${name}`);
  } catch (error) {
    failures += 1;
    console.log(`FAIL ${name}\n     ${error.message}`);
  }
}
console.log(`\n${cases.length - failures}/${cases.length} passed`);
process.exit(failures === 0 ? 0 : 1);
