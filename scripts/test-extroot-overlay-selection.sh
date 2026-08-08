#!/usr/bin/env bash
set -euo pipefail

run_script="${1:-}"
hook_script="${2:-}"
helper_script="${3:-}"
device_library="${4:-}"

[[ -f "$run_script" && -f "$hook_script" && -f "$helper_script" && -f "$device_library" ]] || {
	echo "Usage: $0 <extroot-sysupgrade-run> <extroot-sysupgrade-hook> <first-upgrade-helper> <extroot-device-library>" >&2
	exit 2
}

test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

printf '%s\n' 'set -eu' > "$test_dir/functions.sh"
sed '1d' "$device_library" >> "$test_dir/functions.sh"
sed '/^\. \/usr\/libexec\/extroot-device\.sh$/d' "$run_script" |
	awk '/^rollback_external\(\)/ { exit } { print }' >> "$test_dir/functions.sh"
sed '/^\. \/usr\/libexec\/extroot-device\.sh$/d' "$hook_script" |
	awk '/^extroot_sysupgrade_prepare_backup\(\)/ { exit } { print }' >> "$test_dir/functions.sh"
awk '/^image=/ { exit } { print }' "$helper_script" >> "$test_dir/functions.sh"

cat >> "$test_dir/functions.sh" <<'EOF'
uci() {
	case "$*" in
		*"set fstab.external.enabled=1") printf '1\n' > "$TEST_ENABLED_FILE"; return 0;;
		*"commit fstab") return 0;;
	esac
	case "$TEST_MODE:$*" in
		none:*show\ fstab) return 0;;
		internal:*show\ fstab|mixed:*show\ fstab|multiple:*show\ fstab|implicit:*show\ fstab|saved:*show\ fstab|disabledactive:*show\ fstab|deviceactive:*show\ fstab|duplicate:*show\ fstab|mismatch:*show\ fstab|dual:*show\ fstab)
			echo "fstab.internal.target='/overlay'"
			echo "fstab.external.target='/overlay'"
		;;
		internal:*internal.enabled|mixed:*internal.enabled|saved:*internal.enabled|disabledactive:*internal.enabled|deviceactive:*internal.enabled|duplicate:*internal.enabled|mismatch:*internal.enabled|dual:*internal.enabled) echo 0;;
		internal:*external.enabled|saved:*external.enabled|disabledactive:*external.enabled|deviceactive:*external.enabled|duplicate:*external.enabled|mismatch:*external.enabled|dual:*external.enabled)
			[ -f "$TEST_ENABLED_FILE" ] && cat "$TEST_ENABLED_FILE" || echo 0
		;;
		mixed:*external.enabled|multiple:*internal.enabled|multiple:*external.enabled) echo 1;;
		implicit:*internal.enabled) echo 0;;
		implicit:*external.enabled) return 1;;
		saved:*external.target) echo /overlay;;
		disabledactive:*external.uuid|dual:*external.uuid) echo 3bd922e9-c29e-4221-af26-93281dd96ddc;;
		deviceactive:*external.device) echo /dev/sda1;;
		deviceactive:*internal.device) echo /dev/loop0;;
		duplicate:*external.uuid|duplicate:*internal.uuid) echo 3bd922e9-c29e-4221-af26-93281dd96ddc;;
		mismatch:*external.uuid) echo aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee;;
		disabledactive:*internal.uuid|mismatch:*internal.uuid|dual:*internal.uuid) echo 11111111-2222-3333-4444-555555555555;;
		*) return 1;;
	esac
}

block() {
	[ "$1" = info ] || return 1
	case "${2:-}" in
		/dev/sda1|'') echo '/dev/sda1: UUID="3bd922e9-c29e-4221-af26-93281dd96ddc" VERSION="1.0" TYPE="ext4"';;
		/dev/loop0) echo '/dev/loop0: UUID="11111111-2222-3333-4444-555555555555" VERSION="1.0" TYPE="ext4"';;
		*) return 1;;
	esac
}

readlink() {
	[ "$1" = -f ] && [ -n "${2:-}" ] || return 1
	[ "$2" != /dev/missing ] || return 1
	printf '%s\n' "$2"
}

logger() {
	return 0
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
rm -rf "$STATE_DIR"

TEST_MODE=disabledactive
rm -f "$TEST_ENABLED_FILE" "$EXTROOT_DEVICE_MARKER"
[ "$(extroot_repair_active_section "")" = external ]
[ "$(cat "$TEST_ENABLED_FILE")" = 1 ]
[ "$(cat "$EXTROOT_DEVICE_MARKER")" = 3bd922e9-c29e-4221-af26-93281dd96ddc ]

rm -f "$TEST_ENABLED_FILE" "$FIRST_EXTROOT_DEVICE_MARKER"
[ "$(first_extroot_repair_active_section)" = external ]
[ "$(cat "$TEST_ENABLED_FILE")" = 1 ]
[ "$(cat "$FIRST_EXTROOT_DEVICE_MARKER")" = 3bd922e9-c29e-4221-af26-93281dd96ddc ]

rm -f "$TEST_ENABLED_FILE" "$EXTROOT_DEVICE_MARKER"
STATE_DIR="$TEST_STATE_DIR"
repair_active_overlay_config
[ "$(cat "$TEST_ENABLED_FILE")" = 1 ]
[ "$(cat "$STATE_DIR/device_uuid")" = 3bd922e9-c29e-4221-af26-93281dd96ddc ]

TEST_MODE=deviceactive
rm -f "$TEST_ENABLED_FILE" "$EXTROOT_DEVICE_MARKER"
[ "$(extroot_repair_active_section "")" = external ]
[ "$(cat "$TEST_ENABLED_FILE")" = 1 ]

rm -f "$TEST_ENABLED_FILE" "$FIRST_EXTROOT_DEVICE_MARKER"
[ "$(first_extroot_repair_active_section)" = external ]
[ "$(cat "$TEST_ENABLED_FILE")" = 1 ]

TEST_MODE=duplicate
rm -f "$TEST_ENABLED_FILE" "$EXTROOT_DEVICE_MARKER" "$FIRST_EXTROOT_DEVICE_MARKER"
! extroot_repair_active_section "" >/dev/null
! first_extroot_repair_active_section >/dev/null
[ ! -e "$TEST_ENABLED_FILE" ]

TEST_MODE=mismatch
rm -f "$TEST_ENABLED_FILE" "$EXTROOT_DEVICE_MARKER"
! extroot_repair_active_section "" >/dev/null
[ ! -e "$TEST_ENABLED_FILE" ]

TEST_MODE=dual
EXTROOT_MOUNTS_FILE="$TEST_DUAL_MOUNTS"
FIRST_EXTROOT_MOUNTS_FILE="$TEST_DUAL_MOUNTS"
rm -f "$TEST_ENABLED_FILE" "$EXTROOT_DEVICE_MARKER" "$FIRST_EXTROOT_DEVICE_MARKER"
! extroot_repair_active_section "" >/dev/null
! first_extroot_repair_active_section >/dev/null
[ ! -e "$TEST_ENABLED_FILE" ]

TEST_MODE=disabledactive
EXTROOT_MOUNTS_FILE="$TEST_UNRESOLVED_MOUNTS"
FIRST_EXTROOT_MOUNTS_FILE="$TEST_UNRESOLVED_MOUNTS"
rm -f "$TEST_ENABLED_FILE" "$EXTROOT_DEVICE_MARKER" "$FIRST_EXTROOT_DEVICE_MARKER"
! extroot_repair_active_section "" >/dev/null
! first_extroot_repair_active_section >/dev/null
[ ! -e "$TEST_ENABLED_FILE" ]

TEST_MODE=disabledactive
EXTROOT_MOUNTS_FILE="$TEST_INTERNAL_MOUNTS"
FIRST_EXTROOT_MOUNTS_FILE="$TEST_INTERNAL_MOUNTS"
rm -f "$TEST_ENABLED_FILE" "$EXTROOT_DEVICE_MARKER" "$FIRST_EXTROOT_DEVICE_MARKER"
! extroot_repair_active_section "" >/dev/null
! first_extroot_repair_active_section >/dev/null
[ ! -e "$TEST_ENABLED_FILE" ]
EOF

cat > "$test_dir/mounts" <<'EOF'
/dev/sda1 /overlay ext4 rw,relatime 0 0
overlayfs:/overlay / overlay rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work 0 0
EOF
cat > "$test_dir/dual-mounts" <<'EOF'
/dev/sda1 /overlay ext4 rw,relatime 0 0
overlayfs:/overlay / overlay rw,noatime,lowerdir=/overlay/upper:/,upperdir=/ext_overlay/upper,workdir=/ext_overlay/work 0 0
EOF
cat > "$test_dir/internal-mounts" <<'EOF'
/dev/loop0 /overlay ext4 rw,relatime 0 0
overlayfs:/overlay / overlay rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work 0 0
EOF
cat > "$test_dir/unresolved-mounts" <<'EOF'
/dev/missing /overlay ext4 rw,relatime 0 0
overlayfs:/overlay / overlay rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work 0 0
EOF
mkdir -p "$test_dir/overlay"

TEST_STATE_DIR="$test_dir/state" \
TEST_ENABLED_FILE="$test_dir/enabled" \
TEST_DUAL_MOUNTS="$test_dir/dual-mounts" \
TEST_INTERNAL_MOUNTS="$test_dir/internal-mounts" \
TEST_UNRESOLVED_MOUNTS="$test_dir/unresolved-mounts" \
EXTROOT_MOUNTS_FILE="$test_dir/mounts" \
EXTROOT_FS_ROOT="$test_dir/overlay" \
EXTROOT_DEVICE_MARKER="$test_dir/overlay/.extroot-sysupgrade-device-uuid" \
FIRST_EXTROOT_MOUNTS_FILE="$test_dir/mounts" \
FIRST_EXTROOT_FS_ROOT="$test_dir/overlay" \
FIRST_EXTROOT_DEVICE_MARKER="$test_dir/overlay/.extroot-sysupgrade-device-uuid" \
	bash "$test_dir/functions.sh"

rm -rf "$test_dir/state" "$test_dir/overlay"
rm -f "$test_dir/enabled"
mkdir -p "$test_dir/overlay"
TEST_STATE_DIR="$test_dir/state" \
TEST_ENABLED_FILE="$test_dir/enabled" \
TEST_DUAL_MOUNTS="$test_dir/dual-mounts" \
TEST_INTERNAL_MOUNTS="$test_dir/internal-mounts" \
TEST_UNRESOLVED_MOUNTS="$test_dir/unresolved-mounts" \
EXTROOT_MOUNTS_FILE="$test_dir/mounts" \
EXTROOT_FS_ROOT="$test_dir/overlay" \
EXTROOT_DEVICE_MARKER="$test_dir/overlay/.extroot-sysupgrade-device-uuid" \
FIRST_EXTROOT_MOUNTS_FILE="$test_dir/mounts" \
FIRST_EXTROOT_FS_ROOT="$test_dir/overlay" \
FIRST_EXTROOT_DEVICE_MARKER="$test_dir/overlay/.extroot-sysupgrade-device-uuid" \
	dash "$test_dir/functions.sh"

echo "Extroot overlay selection tests passed"
