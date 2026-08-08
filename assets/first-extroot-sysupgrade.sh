#!/bin/sh

FIRST_EXTROOT_MOUNTS_FILE=${FIRST_EXTROOT_MOUNTS_FILE:-/proc/mounts}
FIRST_EXTROOT_FS_ROOT=${FIRST_EXTROOT_FS_ROOT:-/overlay}
FIRST_EXTROOT_DEVICE_MARKER=${FIRST_EXTROOT_DEVICE_MARKER:-$FIRST_EXTROOT_FS_ROOT/.extroot-sysupgrade-device-uuid}

first_extroot_uuid_valid() {
	[ -n "$1" ] || return 1
	case "$1" in
		*[!A-Fa-f0-9-]*) return 1;;
	esac
}

first_extroot_uuid_normalize() {
	printf '%s\n' "$1" | tr A-F a-f
}

first_extroot_overlay_sections() {
	uci -q show fstab | sed -n \
		"s/^fstab\.\([^.=]*\)\.target='\/overlay'$/\1/p"
}

first_extroot_overlay_section() {
	local section sections

	sections="$(first_extroot_overlay_sections)"
	set --
	for section in $sections; do
		[ "$(uci -q get "fstab.$section.enabled")" = "0" ] && continue
		set -- "$@" "$section"
	done
	[ "$#" -le 1 ] || return 2
	[ "$#" -eq 0 ] && return 0
	printf '%s\n' "$1"
}

first_extroot_standard_upper_active() {
	awk '
		$2 == "/" && $3 == "overlay" {
			n = split($4, option, ",")
			for (i = 1; i <= n; i++)
				if (option[i] == "upperdir=/overlay/upper")
					found = 1
		}
		END { exit found ? 0 : 1 }
	' "$FIRST_EXTROOT_MOUNTS_FILE"
}

first_extroot_active_identity() {
	local device marker uuid

	device="$(awk '$2 == "/overlay" { print $1; exit }' "$FIRST_EXTROOT_MOUNTS_FILE")"
	[ -n "$device" ] || return 1
	first_extroot_standard_upper_active || return 2
	device="$(readlink -f "$device")" || return 2
	[ -n "$device" ] || return 2
	if [ ! -e "$FIRST_EXTROOT_DEVICE_MARKER" ]; then
		case "$device" in
			/dev/loop*|/dev/mtd*|/dev/ubi*|/dev/root|rootfs|ubi*) return 1;;
		esac
	fi
	uuid="$(block info "$device" 2>/dev/null |
		sed -n 's#^.* UUID="\([^"]*\)".*#\1#p' | head -n 1)"
	first_extroot_uuid_valid "$uuid" || return 2
	uuid="$(first_extroot_uuid_normalize "$uuid")"
	if [ -e "$FIRST_EXTROOT_DEVICE_MARKER" ]; then
		marker="$(sed -n '1p' "$FIRST_EXTROOT_DEVICE_MARKER")"
		first_extroot_uuid_valid "$marker" || return 2
		[ "$(first_extroot_uuid_normalize "$marker")" = "$uuid" ] || return 2
	fi
	printf '%s\t%s\n' "$device" "$uuid"
}

first_extroot_section_matches() {
	local section="$1"
	local device="$2"
	local uuid="$3"
	local configured

	configured="$(uci -q get "fstab.$section.uuid")"
	if [ -n "$configured" ]; then
		first_extroot_uuid_valid "$configured" || return 1
		[ "$(first_extroot_uuid_normalize "$configured")" = "$uuid" ]
		return
	fi
	configured="$(uci -q get "fstab.$section.device")"
	[ -n "$configured" ] && [ "$(readlink -f "$configured")" = "$device" ]
}

first_extroot_active_section() {
	local device identity section sections uuid

	identity="$(first_extroot_active_identity)"
	case "$?" in
		0) ;;
		1) return 1;;
		*) return 2;;
	esac
	device="$(printf '%s\n' "$identity" | cut -f 1)"
	uuid="$(printf '%s\n' "$identity" | cut -f 2)"
	sections="$(first_extroot_overlay_sections)"
	set --
	for section in $sections; do
		first_extroot_section_matches "$section" "$device" "$uuid" || continue
		set -- "$@" "$section"
	done
	[ "$#" -eq 1 ] || return 2
	printf '%s\n' "$1"
}

first_extroot_active_uuid_for_section() {
	local section="$1"
	local device identity uuid

	identity="$(first_extroot_active_identity)" || return $?
	device="$(printf '%s\n' "$identity" | cut -f 1)"
	uuid="$(printf '%s\n' "$identity" | cut -f 2)"
	first_extroot_section_matches "$section" "$device" "$uuid" || return 2
	printf '%s\n' "$uuid"
}

first_extroot_repair_active_section() {
	local section uuid

	section="$(first_extroot_active_section)"
	case "$?" in
		0) ;;
		1) return 1;;
		*) return 2;;
	esac
	uuid="$(first_extroot_active_uuid_for_section "$section")" || return 2
	uci -q set "fstab.$section.enabled=1" &&
		uci -q commit fstab &&
		[ "$(uci -q get "fstab.$section.enabled")" = "1" ] || return 2
	printf '%s\n' "$uuid" > "$FIRST_EXTROOT_DEVICE_MARKER" || return 2
	printf '%s\n' "$section"
}

image="$1"

usage() {
	echo "Usage: $0 <sysupgrade-image-or-url>" >&2
	exit 2
}

[ -n "$image" ] || usage
case "$image" in
	http://*|https://*) ;;
	*) [ -f "$image" ] || usage;;
esac

section="$(first_extroot_overlay_section)"
status=$?
[ "$status" -ne 2 ] || {
	echo "Multiple enabled /overlay mount sections are configured; refusing sysupgrade." >&2
	exit 1
}

if [ -z "$section" ]; then
	section="$(first_extroot_repair_active_section)"
	status=$?
	case "$status" in
		0) echo "Restored enabled=1 for the active extroot mount.";;
		1) exec sysupgrade -c -k "$image";;
		*)
			echo "Active /overlay identity is unsafe or ambiguous; refusing sysupgrade." >&2
			exit 1
		;;
	esac
fi

device_uuid="$(first_extroot_active_uuid_for_section "$section")" || {
	echo "Configured extroot is not the active /overlay; refusing sysupgrade." >&2
	exit 1
}
printf '%s\n' "$device_uuid" > "$FIRST_EXTROOT_DEVICE_MARKER" || exit 1

old_enabled="$(uci -q get "fstab.$section.enabled")"
[ -n "$old_enabled" ] || old_enabled=1
state_dir=/etc/extroot-sysupgrade

[ ! -e "$state_dir/phase" ] || {
	echo "An extroot migration is already pending." >&2
	exit 1
}

restore_live_state() {
	uci -q set "fstab.$section.enabled=$old_enabled"
	uci -q commit fstab
	rm -f "$state_dir/section" "$state_dir/phase"
	rmdir "$state_dir" 2>/dev/null || true
}

mkdir -p "$state_dir" || exit 1
printf '%s\n' "$section" > "$state_dir/section"
printf '%s\n' prepare > "$state_dir/phase"
printf '%s\n' "$device_uuid" > "$state_dir/device_uuid"

uci -q set "fstab.$section.enabled=0" && uci -q commit fstab || {
	restore_live_state
	echo "Failed to disable extroot for the bootstrap upgrade." >&2
	exit 1
}

trap restore_live_state EXIT INT TERM
echo "Extroot is disabled in the upgrade backup; starting bootstrap sysupgrade."
sysupgrade -c -k "$image"
ret=$?
restore_live_state
trap - EXIT INT TERM
exit "$ret"
