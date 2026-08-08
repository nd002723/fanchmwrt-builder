#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

source_dir="${1:-}"
builder_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

[[ -n "$source_dir" ]] || { echo "Usage: $0 <source-directory>" >&2; exit 2; }
source_dir="$(cd "$source_dir" && pwd)"
source "$source_dir/.builder-target"
target_dir="$source_dir/bin/targets/$TARGET/$SUBTARGET"
manifest="$(find "$target_dir" -maxdepth 1 -name "*${PROFILE}.manifest" -print -quit)"
if [[ -z "$manifest" ]]; then
	manifests=("$target_dir"/*.manifest)
	(( ${#manifests[@]} == 1 )) || {
		echo "Could not identify the firmware manifest for profile $PROFILE" >&2
		exit 1
	}
	manifest="${manifests[0]}"
fi

while IFS= read -r package; do
	[[ -n "$package" && "$package" != \#* ]] || continue
	grep -Fxq "CONFIG_PACKAGE_${package}=y" "$source_dir/.config" || {
		echo "Required package is not enabled: $package" >&2
		exit 1
	}
	grep -q "^${package} - " "$manifest" || {
		echo "Required package is missing from firmware manifest: $package" >&2
		exit 1
	}
done < "$builder_root/configs/required-packages.txt"

rootfs="$(find "$source_dir/build_dir" -maxdepth 3 -type d -name 'root-*' -print | head -n 1)"
[[ -n "$rootfs" ]] || { echo "Root filesystem staging directory not found" >&2; exit 1; }
test -x "$rootfs/usr/libexec/extroot-sysupgrade"
test -r "$rootfs/usr/libexec/extroot-device.sh"
test -x "$rootfs/usr/libexec/package-manager-call"
test -x "$rootfs/etc/uci-defaults/99-fanchmwrt-repositories"
grep -Fxq '/etc/config/ddnsto' "$rootfs/lib/upgrade/keep.d/ddnsto"
grep -q 'https://mirror.nju.edu.cn/openwrt' \
	"$rootfs/etc/uci-defaults/99-fanchmwrt-repositories"
grep -Fq 'cp -f /rom/etc/apk/world /etc/apk/world' \
	"$rootfs/etc/uci-defaults/99-fanchmwrt-repositories"

grep -Fxq 'SAVE_OVERLAY=1' "$source_dir/package/base-files/files/sbin/sysupgrade"
grep -Fxq 'SAVE_OVERLAY_PATH=/etc' "$source_dir/package/base-files/files/sbin/sysupgrade"
grep -Fq 'sysupgrade -c -k "$image"' \
	"$builder_root/assets/first-extroot-sysupgrade.sh"
grep -Fxq 'SAVE_INSTALLED_PKGS=1' "$source_dir/package/base-files/files/sbin/sysupgrade"
grep -Fq '"$workdir/etc/apk/world"' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade.sh"
grep -Fq 'restore_unowned_files "$backup_dir/upper"' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run"
grep -Fq 'skipping unowned file because its parent conflicts with the new root' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run"
grep -Fq 'awk '\''$2 == "overlay" { print $1 }'\'' "$MANIFEST"' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run"
grep -Fq 'repository_origin_matches_old "$package"' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run"
grep -Fq 'firmware_has_package "$package" && continue' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run"
grep -Fq 'grep -Fxq "$path" "$replaced" && continue' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run"
grep -Fq 'multiple enabled /overlay mount sections are configured' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run"
grep -Fq 'overlay_device_identity_matches "$section" "$device"' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run"
grep -Fq 'repair_active_overlay_config || fail' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run"
grep -Fq 'extroot_repair_active_section "$config_dir"' \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade.sh"
bash "$builder_root/scripts/test-extroot-overlay-selection.sh" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade.sh" \
	"$builder_root/assets/first-extroot-sysupgrade.sh" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-device.sh"

for script in \
	"$source_dir/package/base-files/files/etc/uci-defaults/99-fanchmwrt-repositories" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/95-extroot-sysupgrade" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-device.sh" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade.init" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade.sh" \
	"$builder_root/overlay/feeds_patches/luci/applications/luci-app-package-manager/root/usr/libexec/package-manager-call" \
	"$builder_root/assets/first-extroot-sysupgrade.sh"; do
	sh -n "$script"
done

echo "Firmware verification passed: $manifest"
