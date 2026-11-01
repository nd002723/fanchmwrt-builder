'use strict';

// Locks the shared label vocabulary. Four workflows apply these labels, so a
// typo in a name, a colour that is not a hex triplet, or a description GitHub
// will reject must fail here rather than at the moment a build request needs it.

const assert = require('assert');
const { LABELS, ensureLabel, ensureAllLabels } = require('./lib/labels.js');

let failures = 0;
function check(name, fn) {
  try {
    fn();
    console.log(`ok   ${name}`);
  } catch (error) {
    console.error(`FAIL ${name}\n     ${error.message}`);
    failures += 1;
  }
}

check('every colour is a six digit hex triplet', () => {
  for (const [name, definition] of Object.entries(LABELS)) {
    assert.match(definition.color, /^[0-9a-f]{6}$/, `${name} colour`);
  }
});

check('every description is short enough for the API', () => {
  for (const [name, definition] of Object.entries(LABELS)) {
    assert.ok(definition.description.length > 0, `${name} has no description`);
    assert.ok(definition.description.length <= 100, `${name} description is ${definition.description.length} chars`);
  }
});

check('the label names the workflows apply all exist', () => {
  const used = [
    'build-firmware',
    'build-review-pending',
    'build-queued',
    'build-dispatching',
    'approved-build',
    'duplicate',
    'force-build',
    'needs-owner-review',
    'build-attention',
  ];
  for (const name of used) {
    assert.ok(LABELS[name], `${name} is applied by a workflow but not declared`);
  }
  assert.deepStrictEqual(Object.keys(LABELS).sort(), used.sort(), 'the table holds an unused label');
});

check('the attention label stays yellow', () => {
  // Yellow is what makes a failed build findable in the issue list; a colour
  // change here should be a deliberate edit, not a merge accident.
  assert.strictEqual(LABELS['build-attention'].color, 'fbca04');
  assert.strictEqual(LABELS['needs-owner-review'].color, 'b60205');
});

function fakeGithub(existing) {
  const created = [];
  return {
    created,
    rest: {
      issues: {
        async getLabel({ name }) {
          if (!existing.includes(name)) {
            const error = new Error('Not Found');
            error.status = 404;
            throw error;
          }
          return { data: { name } };
        },
        async createLabel(payload) {
          if (existing.includes(payload.name)) {
            const error = new Error('Validation Failed');
            error.status = 422;
            throw error;
          }
          created.push(payload);
          return { data: payload };
        },
      },
    },
  };
}

const context = { repo: { owner: 'o', repo: 'r' } };

(async () => {
  const github = fakeGithub(Object.keys(LABELS));
  const created = await ensureAllLabels(github, context);
  try {
    assert.deepStrictEqual(created, [], 'nothing should be created');
    console.log('ok   a fully labelled repository creates nothing');
  } catch (error) {
    console.error(`FAIL a fully labelled repository creates nothing\n     ${error.message}`);
    failures += 1;
  }

  const empty = fakeGithub([]);
  const made = await ensureAllLabels(empty, context);
  try {
    assert.strictEqual(made.length, Object.keys(LABELS).length, 'every label should be created');
    for (const payload of empty.created) {
      assert.ok(LABELS[payload.name], `${payload.name} is not declared`);
      assert.strictEqual(payload.color, LABELS[payload.name].color, `${payload.name} colour`);
    }
    console.log('ok   an empty repository receives the whole table');
  } catch (error) {
    console.error(`FAIL an empty repository receives the whole table\n     ${error.message}`);
    failures += 1;
  }

  let rejected = false;
  try {
    await ensureLabel(fakeGithub([]), context, 'no-such-label');
  } catch (error) {
    rejected = /Unknown label/.test(error.message);
  }
  if (rejected) {
    console.log('ok   an undeclared label is refused instead of created blind');
  } else {
    console.error('FAIL an undeclared label is refused instead of created blind');
    failures += 1;
  }

  if (failures > 0) {
    console.error(`\n${failures} test(s) failed`);
    process.exit(1);
  }
  console.log('\nAll label tests passed');
})();
