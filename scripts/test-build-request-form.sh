#!/usr/bin/env bash
set -euo pipefail

builder_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
parser="$builder_root/scripts/parse-build-issue.py"
renderer="$builder_root/scripts/render-upstream-refs.py"
issue_form="$builder_root/.github/ISSUE_TEMPLATE/firmware-build.yml"
workflow_file="$builder_root/.github/workflows/build.yml"

for script in "$parser" "$renderer"; do
	[[ -f "$script" ]] || {
		echo "Missing script: $script" >&2
		exit 2
	}
done

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

failures=0
pass() { printf 'ok   %s\n' "$1"; }
fail_case() { printf 'FAIL %s\n' "$1"; failures=$((failures + 1)); }

parse_accept() {
	local name="$1" body="$2" expected_ref="$3"
	local out="$work_dir/out-$RANDOM" err="$work_dir/err-$RANDOM" actual
	: > "$out"
	if ISSUE_TITLE='[Firmware Build] test device' ISSUE_BODY="$body" GITHUB_OUTPUT="$out" \
		python3 "$parser" >/dev/null 2>"$err"; then
		actual="$(sed -n 's/^upstream_ref=//p' "$out")"
		if [[ "$actual" == "$expected_ref" ]]; then
			pass "$name"
		else
			fail_case "$name (expected upstream_ref=${expected_ref}, got ${actual:-<none>})"
		fi
	else
		fail_case "$name (unexpected rejection: $(cat "$err"))"
	fi
}

parse_reject() {
	local name="$1" body="$2"
	local out="$work_dir/out-reject" err="$work_dir/err-reject"
	: > "$out"
	if ISSUE_TITLE='[Firmware Build] test device' ISSUE_BODY="$body" GITHUB_OUTPUT="$out" \
		python3 "$parser" >/dev/null 2>"$err"; then
		fail_case "$name (accepted, expected rejection)"
	else
		pass "$name"
	fi
}

# --- Issue Form parsing -----------------------------------------------------

parse_accept "dropdown selection without override" "$(cat <<'BODY'
### Upstream ref

v25.12.4

### Upstream ref override

_No response_

### Architecture

mipsel

### Target

ramips

### Subtarget

mt7621

### Profile

xiaoyu_xy-c5
BODY
)" "v25.12.4"

parse_accept "branch override wins over dropdown" "$(cat <<'BODY'
### Upstream ref

v25.12.6

### Upstream ref override

fanchmwrt-25.12.4

### Architecture

arm

### Target

rockchip

### Subtarget

armv8

### Profile

friendlyarm_nanopi-r5c
BODY
)" "fanchmwrt-25.12.4"

parse_accept "commit SHA override wins over dropdown" "$(cat <<'BODY'
### Upstream ref

v25.12.6

### Upstream ref override

f6cb1f7288cf6f7e1f471ff84841702193261e0a

### Architecture

x86

### Target

x86

### Subtarget

64

### Profile

generic
BODY
)" "f6cb1f7288cf6f7e1f471ff84841702193261e0a"

parse_accept "legacy issue without the override field" "$(cat <<'BODY'
### Upstream ref

fanchmwrt-25.12.4

### Architecture

mipsel

### Target

ramips

### Subtarget

mt7621

### Profile

xiaoyu_xy-c5
BODY
)" "fanchmwrt-25.12.4"

parse_reject "override with a parent directory segment" "$(cat <<'BODY'
### Upstream ref

v25.12.6

### Upstream ref override

../main

### Architecture

mipsel

### Target

ramips

### Subtarget

mt7621

### Profile

xiaoyu_xy-c5
BODY
)"

parse_reject "missing architecture" "$(cat <<'BODY'
### Upstream ref

v25.12.6

### Upstream ref override

_No response_

### Target

ramips

### Subtarget

mt7621

### Profile

xiaoyu_xy-c5
BODY
)"

parse_reject "duplicate field" "$(cat <<'BODY'
### Upstream ref

v25.12.6

### Upstream ref

v25.12.5

### Architecture

mipsel

### Target

ramips

### Subtarget

mt7621

### Profile

xiaoyu_xy-c5
BODY
)"

# --- upstream_ref choice rendering ------------------------------------------

cp "$issue_form" "$work_dir/form.yml"
cp "$workflow_file" "$work_dir/build.yml"
cat > "$work_dir/tags.json" <<'JSON'
[
  "v25.12.6",
  "v25.12.5",
  "v25.12.4",
  "v25.12.0-rc3",
  "v24.10.0-rc7",
  "reboot",
  "fanchmwrt24.10.4-1.0.1"
]
JSON

render() {
	: > "$work_dir/render.out"
	GITHUB_OUTPUT="$work_dir/render.out" python3 "$renderer" \
		--tags "$1" --issue-form "$2" --workflow-file "$3" >/dev/null
	sed -n 's/^changed=//p' "$work_dir/render.out"
}

if [[ "$(render "$work_dir/tags.json" "$work_dir/form.yml" "$work_dir/build.yml")" == "1" ]]; then
	pass "first render reports a change"
else
	fail_case "first render reports a change"
fi

if [[ "$(sed -n '/BEGIN upstream_ref options/,/END upstream_ref options/p' "$work_dir/form.yml" |
	sed -n 's/^        - //p' | paste -sd, -)" == "v25.12.6,v25.12.5,v25.12.4" ]]; then
	pass "prereleases and unrelated tags are dropped, newest first"
else
	fail_case "prereleases and unrelated tags are dropped, newest first"
fi

cp "$issue_form" "$work_dir/form-branch.yml"
cp "$workflow_file" "$work_dir/build-branch.yml"
cat > "$work_dir/branches.json" <<'JSON'
[
  "fanchmwrt-25.12.6",
  "fanchmwrt-25.12.4",
  "openwrt-main"
]
JSON

if [[ "$(GITHUB_OUTPUT=/dev/null python3 "$renderer" \
	--tags "$work_dir/tags.json" --branches "$work_dir/branches.json" \
	--issue-form "$work_dir/form-branch.yml" --workflow-file "$work_dir/build-branch.yml" >/dev/null
	sed -n '/BEGIN upstream_ref options/,/END upstream_ref options/p' "$work_dir/form-branch.yml" |
	sed -n 's/^        - //p' | paste -sd, -)" == "fanchmwrt-25.12.6,v25.12.6,v25.12.5,fanchmwrt-25.12.4,v25.12.4" ]]; then
	pass "maintenance branches are interleaved directly before their tags"
else
	fail_case "maintenance branches are interleaved directly before their tags"
fi

# The default follows the maintenance branch of the newest version: the bare
# tag carries no private fanchmwrt layer, so defaulting to it would fail
# verification (missing luci-app-fwx-app-center) on the first stock run.
if [[ "$(sed -n '/BEGIN upstream_ref default/,/END upstream_ref default/p' "$work_dir/build-branch.yml" |
	sed -n 's/^        default: //p')" == "fanchmwrt-25.12.6" ]]; then
	pass "the dispatch default follows the maintenance branch"
else
	fail_case "the dispatch default follows the maintenance branch"
fi

if [[ "$(sed -n '/BEGIN upstream_ref default/,/END upstream_ref default/p' "$work_dir/build.yml" |
	sed -n 's/^        default: //p')" == "v25.12.6" ]]; then
	pass "workflow dispatch default tracks the newest release"
else
	fail_case "workflow dispatch default tracks the newest release"
fi

if [[ "$(sed -n '/BEGIN upstream_ref options/,/END upstream_ref options/p' "$work_dir/build.yml" |
	sed -n 's/^          - //p' | paste -sd, -)" == "v25.12.6,v25.12.5,v25.12.4" ]]; then
	pass "manual dispatch offers the same choices as the Issue Form"
else
	fail_case "manual dispatch offers the same choices as the Issue Form"
fi

if [[ "$(python3 -c 'import sys, yaml
loaded = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
triggers = loaded.get("on") or loaded.get(True)
ref = triggers["workflow_dispatch"]["inputs"]["upstream_ref"]
print(ref["type"], len(ref["options"]), ref["default"] in ref["options"])' "$work_dir/build.yml")" == "choice 3 True" ]]; then
	pass "manual dispatch input is a choice list with a valid default"
else
	fail_case "manual dispatch input is a choice list with a valid default"
fi

# --- upstream-declared maintenance downgrade ---------------------------------
# Upstream owns the decision about its own maintenance layer. A release that
# announces a repair must withdraw the older `fanchmwrt-<version>` branches,
# otherwise the builder keeps offering a branch upstream already called stale.

cp "$issue_form" "$work_dir/form-down.yml"
cp "$workflow_file" "$work_dir/build-down.yml"
cat > "$work_dir/manifest.json" <<'JSON'
{
  "schema_version": 1,
  "maintenance": {
    "v25.12.6": "maintenance",
    "v25.12.5": "silent"
  }
}
JSON

if [[ "$(GITHUB_OUTPUT=/dev/null python3 "$renderer" \
	--tags "$work_dir/tags.json" --branches "$work_dir/branches.json" \
	--downgrade "$work_dir/manifest.json" \
	--issue-form "$work_dir/form-down.yml" --workflow-file "$work_dir/build-down.yml" >/dev/null
	sed -n '/BEGIN upstream_ref options/,/END upstream_ref options/p' "$work_dir/form-down.yml" |
	sed -n 's/^        - //p' | paste -sd, -)" == \
	"fanchmwrt-25.12.6,v25.12.6,v25.12.5,v25.12.4" ]]; then
	pass "a repairing release withdraws the older maintenance branches"
else
	fail_case "a repairing release withdraws the older maintenance branches"
fi

if [[ "$(sed -n '/BEGIN upstream_ref default/,/END upstream_ref default/p' "$work_dir/build-down.yml" |
	sed -n 's/^        default: //p')" == "fanchmwrt-25.12.6" ]]; then
	pass "the repaired branch stays the default"
else
	fail_case "the repaired branch stays the default"
fi

# The newest version can withdraw its own branch. The dispatch default then has
# to fall back to the tag, because the Issue Form can only preselect index 0 and
# the renderer rejects a default that is not the first choice.
cp "$issue_form" "$work_dir/form-silent.yml"
cp "$workflow_file" "$work_dir/build-silent.yml"
cat > "$work_dir/manifest-silent.json" <<'JSON'
{"schema_version": 1, "maintenance": {"v25.12.6": "silent"}}
JSON

if [[ "$(GITHUB_OUTPUT=/dev/null python3 "$renderer" \
	--tags "$work_dir/tags.json" --branches "$work_dir/branches.json" \
	--downgrade "$work_dir/manifest-silent.json" \
	--issue-form "$work_dir/form-silent.yml" --workflow-file "$work_dir/build-silent.yml" >/dev/null
	sed -n '/BEGIN upstream_ref options/,/END upstream_ref options/p' "$work_dir/form-silent.yml" |
	sed -n 's/^        - //p' | paste -sd, -)" == \
	"v25.12.6,v25.12.5,fanchmwrt-25.12.4,v25.12.4" ]]; then
	pass "a withdrawn newest branch drops out of the choices"
else
	fail_case "a withdrawn newest branch drops out of the choices"
fi

if [[ "$(sed -n '/BEGIN upstream_ref default/,/END upstream_ref default/p' "$work_dir/build-silent.yml" |
	sed -n 's/^        default: //p')" == "v25.12.6" ]]; then
	pass "the default falls back to the tag when its branch is withdrawn"
else
	fail_case "the default falls back to the tag when its branch is withdrawn"
fi

# A manifest the builder cannot read must never break the sync.
cp "$issue_form" "$work_dir/form-nomani.yml"
cp "$workflow_file" "$work_dir/build-nomani.yml"
if [[ "$(GITHUB_OUTPUT=/dev/null python3 "$renderer" \
	--tags "$work_dir/tags.json" --branches "$work_dir/branches.json" \
	--downgrade "$work_dir/absent.json" \
	--issue-form "$work_dir/form-nomani.yml" --workflow-file "$work_dir/build-nomani.yml" >/dev/null
	sed -n '/BEGIN upstream_ref options/,/END upstream_ref options/p' "$work_dir/form-nomani.yml" |
	sed -n 's/^        - //p' | paste -sd, -)" == \
	"fanchmwrt-25.12.6,v25.12.6,v25.12.5,fanchmwrt-25.12.4,v25.12.4" ]]; then
	pass "a missing upstream manifest keeps every maintenance branch"
else
	fail_case "a missing upstream manifest keeps every maintenance branch"
fi

if [[ "$(grep -c '^      default: 0$' "$work_dir/form.yml")" == "1" ]]; then
	pass "dropdown keeps index 0 as the default selection"
else
	fail_case "dropdown keeps index 0 as the default selection"
fi

if [[ "$(render "$work_dir/tags.json" "$work_dir/form.yml" "$work_dir/build.yml")" == "0" ]]; then
	pass "second render is a no-op"
else
	fail_case "second render is a no-op"
fi

if python3 -c 'import sys, yaml
for path in sys.argv[1:]:
    with open(path, encoding="utf-8") as handle:
        yaml.safe_load(handle)' "$work_dir/form.yml" "$work_dir/build.yml" >/dev/null 2>&1; then
	pass "rendered YAML stays valid"
else
	fail_case "rendered YAML stays valid"
fi

printf '### Rendered Issue Form choice block\n'
sed -n '/BEGIN upstream_ref options/,/END upstream_ref options/p' "$work_dir/form.yml"

if (( failures > 0 )); then
	printf '\n%d test(s) failed\n' "$failures" >&2
	exit 1
fi
printf '\nAll build request form tests passed\n'
