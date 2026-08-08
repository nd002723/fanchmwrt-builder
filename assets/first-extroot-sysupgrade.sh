#!/bin/sh

first_extroot_overlay_section() {
	local section sections

	sections="$(uci -q show fstab | sed -n \
		"s/^fstab\.\([^.=]*\)\.target='\/overlay'$/\1/p")"
	set --
	for section in $sections; do
		[ "$(uci -q get "fstab.$section.enabled")" = "0" ] && continue
		set -- "$@" "$section"
	done
	[ "$#" -le 1 ] || return 1
	[ "$#" -eq 0 ] && return 0
	printf '%s\n' "$1"
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

section="$(first_extroot_overlay_section)" || {
	echo "Multiple enabled /overlay mount sections are configured; refusing sysupgrade." >&2
	exit 1
}

if [ -z "$section" ]; then
	exec sysupgrade -c -k "$image"
fi

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
