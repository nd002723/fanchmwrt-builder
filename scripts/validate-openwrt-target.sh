#!/usr/bin/env bash
set -euo pipefail

source_dir="${1:-}"
target="${2:-}"
subtarget="${3:-}"
profile="${4:-}"
architecture="${5:-}"

if [[ -z "$source_dir" || -z "$target" || -z "$subtarget" || \
	-z "$profile" || -z "$architecture" ]]; then
	echo "Usage: $0 <source> <target> <subtarget> <profile> <architecture>" >&2
	exit 2
fi

for value in "$target" "$subtarget" "$profile"; do
	[[ "$value" =~ ^[A-Za-z0-9][A-Za-z0-9_.+-]*$ ]] || {
		echo "Invalid OpenWrt target component: $value" >&2
		exit 2
	}
done
case "$architecture" in
	mipsel|arm|x86) ;;
	*) echo "Architecture must be one of: mipsel, arm, x86" >&2; exit 2 ;;
esac

source_dir="$(cd "$source_dir" && pwd)"
target_dir="$source_dir/target/linux/$target"
dump_script="$source_dir/scripts/dump-target-info.pl"

[[ -f "$target_dir/Makefile" && -f "$dump_script" ]] || {
	echo "OpenWrt target does not exist: $target" >&2
	exit 1
}

if ! target_info="$(
	make -C "$target_dir" --no-print-directory \
		DUMP=1 TARGET_BUILD=1 SUBTARGET="$subtarget" 2>/dev/null
)"; then
	echo "OpenWrt could not load target: $target/$subtarget" >&2
	exit 1
fi

selected_target="$(
	printf '%s\n' "$target_info" |
		awk -F ': ' '$1 == "Target" { print $2; exit }'
)"
arch_packages="$(
	printf '%s\n' "$target_info" |
		awk -F ': ' '$1 == "Target-Arch-Packages" { print $2; exit }'
)"
if [[ "$selected_target" != "$target/$subtarget" || -z "$arch_packages" ]]; then
	echo "OpenWrt subtarget does not exist: $target/$subtarget" >&2
	exit 1
fi

device_info="$(
	cd "$source_dir"
	"$dump_script" devices "$target/$subtarget" 2>/dev/null
)"
if ! printf '%s\n' "$device_info" |
	awk -v requested="$profile" '$1 == requested { found = 1 } END { exit !found }'; then
	echo "OpenWrt device profile does not exist: $target/$subtarget/$profile" >&2
	exit 1
fi

case "$architecture:$arch_packages" in
	mipsel:mipsel*) ;;
	arm:arm*|arm:aarch64*) ;;
	x86:i386*|x86:x86_64*) ;;
	*)
		echo "Architecture mismatch: requested $architecture, target uses $arch_packages" >&2
		exit 1
		;;
esac

echo "Validated $target/$subtarget/$profile ($architecture, $arch_packages)"
