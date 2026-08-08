#!/usr/bin/env bash
set -euo pipefail

run_script="${1:-}"
hook_script="${2:-}"
helper_script="${3:-}"

[[ -f "$run_script" && -f "$hook_script" && -f "$helper_script" ]] || {
	echo "Usage: $0 <extroot-sysupgrade-run> <extroot-sysupgrade-hook> <first-upgrade-helper>" >&2
	exit 2
}

test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

printf '%s\n' 'set -euo pipefail' > "$test_dir/functions.sh"
awk '/^set_overlay_enabled\(\)/ { exit } { print }' "$run_script" >> "$test_dir/functions.sh"
awk '/^extroot_sysupgrade_prepare_backup\(\)/ { exit } { print }' "$hook_script" >> "$test_dir/functions.sh"
awk '/^image=/ { exit } { print }' "$helper_script" >> "$test_dir/functions.sh"

cat >> "$test_dir/functions.sh" <<'EOF'
uci() {
	case "$TEST_MODE:$*" in
		none:*show\ fstab) return 0;;
		internal:*show\ fstab|mixed:*show\ fstab|multiple:*show\ fstab|implicit:*show\ fstab|saved:*show\ fstab)
			echo "fstab.internal.target='/overlay'"
			echo "fstab.external.target='/overlay'"
		;;
		internal:*internal.enabled|mixed:*internal.enabled|saved:*internal.enabled) echo 0;;
		internal:*external.enabled|saved:*external.enabled) echo 0;;
		mixed:*external.enabled|multiple:*internal.enabled|multiple:*external.enabled) echo 1;;
		implicit:*internal.enabled) echo 0;;
		implicit:*external.enabled) return 1;;
		saved:*external.target) echo /overlay;;
		*) return 1;;
	esac
}

TEST_MODE=none
[ -z "$(discover_overlay_section)" ]
[ -z "$(extroot_sysupgrade_overlay_section /tmp/mock-config)" ]
[ -z "$(first_extroot_overlay_section)" ]

TEST_MODE=internal
[ -z "$(discover_overlay_section)" ]
[ -z "$(extroot_sysupgrade_overlay_section /tmp/mock-config)" ]
[ -z "$(first_extroot_overlay_section)" ]

TEST_MODE=mixed
[ "$(discover_overlay_section)" = external ]
[ "$(extroot_sysupgrade_overlay_section /tmp/mock-config)" = external ]
[ "$(first_extroot_overlay_section)" = external ]

TEST_MODE=implicit
[ "$(discover_overlay_section)" = external ]
[ "$(extroot_sysupgrade_overlay_section /tmp/mock-config)" = external ]
[ "$(first_extroot_overlay_section)" = external ]

TEST_MODE=multiple
! discover_overlay_section >/dev/null
! extroot_sysupgrade_overlay_section /tmp/mock-config >/dev/null
! first_extroot_overlay_section >/dev/null

TEST_MODE=saved
STATE_DIR="${TEST_STATE_DIR:?}"
mkdir -p "$STATE_DIR"
printf '%s\n' external > "$STATE_DIR/section"
[ "$(overlay_section)" = external ]
EOF

TEST_STATE_DIR="$test_dir/state" bash "$test_dir/functions.sh"
echo "Extroot overlay selection tests passed"
