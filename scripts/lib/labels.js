'use strict';

// The label vocabulary, in one place.
//
// Four workflows create or apply these labels, and a colour or description that
// drifted between them was invisible until someone read the rendered label list.
// The definitions live here, so a new workflow can only reference a label that
// already exists in this table, and changing one is a single edit.

const LABELS = Object.freeze({
  'build-firmware': {
    color: '0e8a16',
    description: 'Firmware build request (Issue Form default label)',
  },
  'build-review-pending': {
    color: 'c5def5',
    description: 'Validated request waiting for queue review',
  },
  'build-queued': {
    color: 'd4c5f9',
    description: 'Waiting for an automatic build slot',
  },
  'build-dispatching': {
    color: '1d76db',
    description: 'Reserved automatic build slot',
  },
  'approved-build': {
    color: '0075ca',
    description: 'Approved by the repository owner',
  },
  duplicate: {
    color: 'cfd3d7',
    description: 'An identical successful build is still downloadable',
  },
  'force-build': {
    color: '5319e7',
    description: 'Owner-only: rebuild even when an identical successful build still has artifacts',
  },
  'needs-owner-review': {
    color: 'b60205',
    description: 'Requires repository owner approval',
  },
  // A failed or cancelled build used to disappear into the closed issue list.
  // This is the one label a maintainer is expected to answer, so it can be
  // filtered on without reading every closed request.
  'build-attention': {
    color: 'fbca04',
    description: 'Needs a maintainer to look at a failed or cancelled build',
  },
});

/**
 * Create a label if the repository does not have it yet.
 *
 * Returns true when the label had to be created. A 422 means it exists (possibly
 * with different metadata), which is not an error: the point is that applying it
 * will work.
 */
async function ensureLabel(github, context, name) {
  const definition = LABELS[name];
  if (!definition) {
    throw new Error(`Unknown label "${name}"; add it to scripts/lib/labels.js`);
  }
  try {
    await github.rest.issues.getLabel({
      owner: context.repo.owner,
      repo: context.repo.repo,
      name,
    });
    return false;
  } catch (error) {
    if (error.status !== 404) throw error;
  }
  try {
    await github.rest.issues.createLabel({
      owner: context.repo.owner,
      repo: context.repo.repo,
      name,
      // `color` is a string in the REST API; colours are not numbers.
      color: definition.color,
      description: definition.description.slice(0, 100),
    });
    return true;
  } catch (error) {
    if (error.status === 422) return false;
    throw error;
  }
}

/** Create every label this repository relies on; returns the missing ones. */
async function ensureAllLabels(github, context) {
  const created = [];
  for (const name of Object.keys(LABELS)) {
    if (await ensureLabel(github, context, name)) created.push(name);
  }
  return created;
}

module.exports = { LABELS, ensureLabel, ensureAllLabels };
