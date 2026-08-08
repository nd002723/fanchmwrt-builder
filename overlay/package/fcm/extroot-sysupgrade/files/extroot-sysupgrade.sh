#!/bin/sh

. /usr/libexec/extroot-device.sh

extroot_sysupgrade_overlay_section() {
	extroot_enabled_overlay_section "$1"
}

extroot_sysupgrade_prepare_backup() {
	local archive="$1"
	local config_dir device_uuid ret section status workdir

	[ -n "$IMAGE" ] || return 0
	[ "$SAVE_CONFIG" -eq 1 ] || return 0
	[ -f "$archive" ] || return 1

	workdir="$(mktemp -d /tmp/extroot-sysupgrade.XXXXXX)" || return 1
	tar -C "$workdir" -xzf "$archive" || {
		rm -rf "$workdir"
		return 1
	}

	config_dir="$workdir/etc/config"
	section="$(extroot_sysupgrade_overlay_section "$config_dir")"
	status=$?
	[ "$status" -ne 2 ] || {
		echo "Multiple enabled /overlay mount sections are configured; refusing sysupgrade." >&2
		rm -rf "$workdir"
		return 1
	}
	if [ -z "$section" ]; then
		section="$(extroot_repair_active_section "$config_dir")"
		status=$?
		case "$status" in
			0) echo "Restored enabled=1 for the active extroot in the upgrade backup.";;
			1) section="";;
			*)
				echo "Active /overlay identity is unsafe or ambiguous; refusing sysupgrade." >&2
				rm -rf "$workdir"
				return 1
			;;
		esac
	fi

	# Always use APK state owned by the new firmware. The first-boot default
	# copies world/repositories from /rom and applies the configured mirror.
	rm -f \
		"$workdir/etc/apk/world" \
		"$workdir/etc/apk/repositories.d/distfeeds.list" \
		"$workdir/etc/apk/repositories.d/customfeeds.list"

	if [ -n "$section" ]; then
		device_uuid="$(extroot_active_uuid_for_section "$config_dir" "$section")" || {
			echo "Configured extroot is not the active /overlay; refusing sysupgrade." >&2
			rm -rf "$workdir"
			return 1
		}
		extroot_write_device_marker "$device_uuid" || {
			echo "Failed to record the active extroot UUID; refusing sysupgrade." >&2
			rm -rf "$workdir"
			return 1
		}
		mkdir -p "$workdir/etc/extroot-sysupgrade" || {
			rm -rf "$workdir"
			return 1
		}
		printf '%s\n' "$section" > "$workdir/etc/extroot-sysupgrade/section"
		printf '%s\n' prepare > "$workdir/etc/extroot-sysupgrade/phase"
		printf '%s\n' "$device_uuid" > "$workdir/etc/extroot-sysupgrade/device_uuid"

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
