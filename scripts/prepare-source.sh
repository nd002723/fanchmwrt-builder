#!/usr/bin/env bash
set -euo pipefail

source_dir="${1:-}"
builder_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -z "$source_dir" ]]; then
	echo "Usage: $0 <fanchmwrt-source-directory>" >&2
	exit 2
fi

if ! git -C "$source_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	echo "Not a Git working tree: $source_dir" >&2
	exit 2
fi

source_dir="$(cd "$source_dir" && pwd)"
origin="$(git -C "$source_dir" remote get-url origin)"
case "$origin" in
	https://github.com/fanchmwrt/fanchmwrt|https://github.com/fanchmwrt/fanchmwrt.git|\
	git@github.com:fanchmwrt/fanchmwrt|git@github.com:fanchmwrt/fanchmwrt.git)
		;;
	*)
		echo "Refusing unexpected upstream remote: $origin" >&2
		exit 1
		;;
esac

if ! git -C "$source_dir" diff --quiet || \
	! git -C "$source_dir" diff --cached --quiet; then
	echo "Upstream checkout is not clean before customization" >&2
	exit 1
fi

if command -v rsync >/dev/null 2>&1; then
	rsync -a "$builder_root/overlay/" "$source_dir/"
else
	cp -a "$builder_root/overlay/." "$source_dir/"
fi

shopt -s nullglob
patches=("$builder_root"/patches/*.patch)
for patch in "${patches[@]}"; do
	echo "Applying ${patch##*/}"
	git -C "$source_dir" apply --check "$patch"
	git -C "$source_dir" apply "$patch"
done

mapfile -d '' config_generators < <(
	find "$source_dir" -path '*/base-files/files/bin/config_generate' -print0
)
if (( ${#config_generators[@]} == 0 )); then
	echo "Could not find base-files config_generate" >&2
	exit 1
fi
for file in "${config_generators[@]}"; do
	sed -i \
		-e 's/192\.168\.1\.1/192.168.100.1/g' \
		-e 's/192\.168\.2\.1/192.168.100.1/g' \
		"$file"
done

chmod +x \
	"$source_dir/package/base-files/files/etc/uci-defaults/99-fanchmwrt-repositories" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/95-extroot-sysupgrade" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade.init" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade-run" \
	"$source_dir/package/fcm/extroot-sysupgrade/files/extroot-sysupgrade.sh"

echo "Customized upstream commit $(git -C "$source_dir" rev-parse HEAD)"
