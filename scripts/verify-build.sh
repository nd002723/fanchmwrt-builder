#!/usr/bin/env bash
set -euo pipefail

source_dir="${1:-}"
builder_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -z "$source_dir" ]]; then
	echo "Usage: $0 <source-directory>" >&2
	exit 2
fi
source_dir="$(cd "$source_dir" && pwd)"

while IFS= read -r package; do
	[[ -n "$package" && "$package" != \#* ]] || continue
	grep -Fxq "CONFIG_PACKAGE_${package}=y" "$source_dir/.config" || {
		echo "Required package is not enabled: $package" >&2
		exit 1
	}
done < "$builder_root/configs/required-packages.txt"

manifest="$(find "$source_dir/bin/targets/ramips/mt7621" -maxdepth 1 \
	-name '*xiaoyu_xy-c5.manifest' -print -quit)"
[[ -n "$manifest" ]]
while IFS= read -r package; do
	[[ -n "$package" && "$package" != \#* ]] || continue
	grep -q "^${package} - " "$manifest" || {
		echo "Required package is missing from firmware manifest: $package" >&2
		exit 1
	}
done < "$builder_root/configs/required-packages.txt"

rootfs="$(find "$source_dir/build_dir" -maxdepth 3 -type d \
	-name 'root-ramips' -print -quit)"
[[ -n "$rootfs" ]]
test -x "$rootfs/usr/libexec/extroot-sysupgrade"
test -x "$rootfs/etc/uci-defaults/99-fanchmwrt-repositories"
grep -Fxq '/etc/config/ddnsto' "$rootfs/lib/upgrade/keep.d/ddnsto"
grep -q 'https://mirror.nju.edu.cn/openwrt' \
	"$rootfs/etc/uci-defaults/99-fanchmwrt-repositories"

grep -Fxq 'SAVE_OVERLAY=1' "$source_dir/package/base-files/files/sbin/sysupgrade"
grep -Fxq 'SAVE_OVERLAY_PATH=/' "$source_dir/package/base-files/files/sbin/sysupgrade"
grep -Fxq 'SAVE_INSTALLED_PKGS=1' "$source_dir/package/base-files/files/sbin/sysupgrade"

for script in \
	"$source_dir/package/base-files/files/etc/uci-defaults/99-fanchmwrt-repositories" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/95-extroot-sysupgrade" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade.init" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade.sh" \
	"$builder_root/assets/first-extroot-sysupgrade.sh"; do
	sh -n "$script"
done

echo "Firmware verification passed: $manifest"

