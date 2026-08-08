#!/bin/sh

extroot_sysupgrade_overlay_section() {
	local config_dir sections

	config_dir="$1"
	sections="$(uci -q -c "$config_dir" show fstab | sed -n \
		"s/^fstab\.\([^.=]*\)\.target='\/overlay'$/\1/p")"
	set -- $sections
	[ "$#" -le 1 ] || return 1
	[ "$#" -eq 0 ] && return 0
	printf '%s\n' "$1"
}

extroot_sysupgrade_prepare_backup() {
	local archive="$1"
	local config_dir ret section workdir

	[ -n "$IMAGE" ] || return 0
	[ "$SAVE_CONFIG" -eq 1 ] || return 0
	[ -f "$archive" ] || return 1

	workdir="$(mktemp -d /tmp/extroot-sysupgrade.XXXXXX)" || return 1
	tar -C "$workdir" -xzf "$archive" || {
		rm -rf "$workdir"
		return 1
	}

	config_dir="$workdir/etc/config"
	section="$(extroot_sysupgrade_overlay_section "$config_dir")" || {
		echo "Multiple /overlay mount sections are configured; refusing sysupgrade." >&2
		rm -rf "$workdir"
		return 1
	}

	# Always use APK state owned by the new firmware. The first-boot default
	# copies world/repositories from /rom and applies the configured mirror.
	rm -f \
		"$workdir/etc/apk/world" \
		"$workdir/etc/apk/repositories.d/distfeeds.list" \
		"$workdir/etc/apk/repositories.d/customfeeds.list"

	if [ -n "$section" ] &&
		[ "$(uci -q -c "$config_dir" get "fstab.$section.enabled")" != "0" ]; then
		mkdir -p "$workdir/etc/extroot-sysupgrade" || {
			rm -rf "$workdir"
			return 1
		}
		printf '%s\n' "$section" > "$workdir/etc/extroot-sysupgrade/section"
		printf '%s\n' prepare > "$workdir/etc/extroot-sysupgrade/phase"

		uci -q -c "$config_dir" set "fstab.$section.enabled=0" &&
			uci -q -c "$config_dir" commit fstab || {
			rm -rf "$workdir"
			return 1
		}
	fi

	tar -C "$workdir" -czf "$archive.new" . && mv "$archive.new" "$archive"
	ret=$?
	rm -rf "$workdir"
	return "$ret"
}

append sysupgrade_post_backup_hooks extroot_sysupgrade_prepare_backup
