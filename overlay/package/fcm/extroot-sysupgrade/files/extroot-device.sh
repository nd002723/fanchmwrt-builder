#!/bin/sh

EXTROOT_MOUNTS_FILE=${EXTROOT_MOUNTS_FILE:-/proc/mounts}
EXTROOT_FS_ROOT=${EXTROOT_FS_ROOT:-/overlay}
EXTROOT_DEVICE_MARKER=${EXTROOT_DEVICE_MARKER:-$EXTROOT_FS_ROOT/.extroot-sysupgrade-device-uuid}

extroot_uci() {
	local config_dir="$1"
	shift
	if [ -n "$config_dir" ]; then
		uci -q -c "$config_dir" "$@"
	else
		uci -q "$@"
	fi
}

extroot_uuid_valid() {
	[ -n "$1" ] || return 1
	case "$1" in
		*[!A-Fa-f0-9-]*) return 1;;
	esac
}

extroot_uuid_normalize() {
	printf '%s\n' "$1" | tr A-F a-f
}

extroot_overlay_sections() {
	local config_dir="$1"

	extroot_uci "$config_dir" show fstab | sed -n \
		"s/^fstab\.\([^.=]*\)\.target='\/overlay'$/\1/p"
}

extroot_enabled_overlay_section() {
	local config_dir="$1"
	local section sections

	sections="$(extroot_overlay_sections "$config_dir")"
	set --
	for section in $sections; do
		[ "$(extroot_uci "$config_dir" get "fstab.$section.enabled")" = "0" ] && continue
		set -- "$@" "$section"
	done
	[ "$#" -le 1 ] || return 2
	[ "$#" -eq 0 ] && return 0
	printf '%s\n' "$1"
}

extroot_standard_upper_active() {
	awk '
		$2 == "/" && $3 == "overlay" {
			n = split($4, option, ",")
			for (i = 1; i <= n; i++)
				if (option[i] == "upperdir=/overlay/upper")
					found = 1
		}
		END { exit found ? 0 : 1 }
	' "$EXTROOT_MOUNTS_FILE"
}

extroot_active_identity() {
	local device marker uuid

	device="$(awk '$2 == "/overlay" { print $1; exit }' "$EXTROOT_MOUNTS_FILE")"
	[ -n "$device" ] || return 1
	extroot_standard_upper_active || return 2

	device="$(readlink -f "$device")" || return 2
	[ -n "$device" ] || return 2
	if [ ! -e "$EXTROOT_DEVICE_MARKER" ]; then
		case "$device" in
			/dev/loop*|/dev/mtd*|/dev/ubi*|/dev/root|rootfs|ubi*) return 1;;
		esac
	fi
	uuid="$(block info "$device" 2>/dev/null |
		sed -n 's#^.* UUID="\([^"]*\)".*#\1#p' | head -n 1)"
	extroot_uuid_valid "$uuid" || return 2
	uuid="$(extroot_uuid_normalize "$uuid")"

	if [ -e "$EXTROOT_DEVICE_MARKER" ]; then
		marker="$(sed -n '1p' "$EXTROOT_DEVICE_MARKER")"
		extroot_uuid_valid "$marker" || return 2
		[ "$(extroot_uuid_normalize "$marker")" = "$uuid" ] || return 2
	fi

	printf '%s\t%s\n' "$device" "$uuid"
}

extroot_section_matches_identity() {
	local config_dir="$1"
	local section="$2"
	local device="$3"
	local uuid="$4"
	local configured

	configured="$(extroot_uci "$config_dir" get "fstab.$section.uuid")"
	if [ -n "$configured" ]; then
		extroot_uuid_valid "$configured" || return 1
		[ "$(extroot_uuid_normalize "$configured")" = "$uuid" ]
		return
	fi

	configured="$(extroot_uci "$config_dir" get "fstab.$section.device")"
	[ -n "$configured" ] || return 1
	[ "$(readlink -f "$configured")" = "$device" ]
}

extroot_active_overlay_section() {
	local config_dir="$1"
	local device identity section sections uuid

	identity="$(extroot_active_identity)"
	case "$?" in
		0) ;;
		1) return 1;;
		*) return 2;;
	esac
	device="$(printf '%s\n' "$identity" | cut -f 1)"
	uuid="$(printf '%s\n' "$identity" | cut -f 2)"

	sections="$(extroot_overlay_sections "$config_dir")"
	set --
	for section in $sections; do
		extroot_section_matches_identity "$config_dir" "$section" "$device" "$uuid" || continue
		set -- "$@" "$section"
	done
	[ "$#" -eq 1 ] || return 2
	printf '%s\n' "$1"
}

extroot_active_uuid_for_section() {
	local config_dir="$1"
	local section="$2"
	local device identity uuid

	identity="$(extroot_active_identity)" || return $?
	device="$(printf '%s\n' "$identity" | cut -f 1)"
	uuid="$(printf '%s\n' "$identity" | cut -f 2)"
	extroot_section_matches_identity "$config_dir" "$section" "$device" "$uuid" || return 2
	printf '%s\n' "$uuid"
}

extroot_enable_section() {
	local config_dir="$1"
	local section="$2"

	extroot_uci "$config_dir" set "fstab.$section.enabled=1" &&
		extroot_uci "$config_dir" commit fstab &&
		[ "$(extroot_uci "$config_dir" get "fstab.$section.enabled")" = "1" ]
}

extroot_write_device_marker() {
	local uuid="$1"

	extroot_uuid_valid "$uuid" || return 1
	printf '%s\n' "$(extroot_uuid_normalize "$uuid")" > "$EXTROOT_DEVICE_MARKER"
}

extroot_repair_active_section() {
	local config_dir="$1"
	local section uuid

	section="$(extroot_active_overlay_section "$config_dir")"
	case "$?" in
		0) ;;
		1) return 1;;
		*) return 2;;
	esac
	uuid="$(extroot_active_uuid_for_section "$config_dir" "$section")" || return 2
	extroot_enable_section "$config_dir" "$section" || return 2
	extroot_write_device_marker "$uuid" || return 2
	printf '%s\n' "$section"
}
