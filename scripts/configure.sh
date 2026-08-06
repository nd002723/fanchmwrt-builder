#!/usr/bin/env bash
set -euo pipefail

source_dir="${1:-}"
config_file="${2:-}"
target="${3:-}"
subtarget="${4:-}"
profile="${5:-}"
architecture="${6:-}"

if [[ -z "$source_dir" || -z "$config_file" || -z "$target" || \
	-z "$subtarget" || -z "$profile" || -z "$architecture" ]]; then
	echo "Usage: $0 <source> <base-config> <target> <subtarget> <profile> <architecture>" >&2
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
config_file="$(cd "$(dirname "$config_file")" && pwd)/$(basename "$config_file")"
tmp_config="$source_dir/.config.builder"
{
	cat "$config_file"
	printf 'CONFIG_TARGET_%s=y\n' "$target"
	printf 'CONFIG_TARGET_%s_%s=y\n' "$target" "$subtarget"
	printf 'CONFIG_TARGET_%s_%s_DEVICE_%s=y\n' "$target" "$subtarget" "$profile"
} > "$tmp_config"
mv "$tmp_config" "$source_dir/.config"
make -C "$source_dir" defconfig

for symbol in \
	"CONFIG_TARGET_${target}" \
	"CONFIG_TARGET_${target}_${subtarget}" \
	"CONFIG_TARGET_${target}_${subtarget}_DEVICE_${profile}"; do
	grep -Fxq "${symbol}=y" "$source_dir/.config" || {
		echo "OpenWrt did not recognize target symbol: $symbol" >&2
		exit 1
	}
done

arch_packages="$(make -s -C "$source_dir" val.ARCH_PACKAGES 2>/dev/null | tail -n 1)"
[[ "$arch_packages" =~ ^[A-Za-z0-9][A-Za-z0-9_.+-]*$ ]] || {
	echo "OpenWrt returned an invalid package architecture: $arch_packages" >&2
	exit 1
}
case "$architecture:$arch_packages" in
	mipsel:mipsel*) ;;
	arm:arm*|arm:aarch64*) ;;
	x86:i386*|x86:x86_64*) ;;
	*)
		echo "Architecture mismatch: requested $architecture, OpenWrt selected $arch_packages" >&2
		exit 1
		;;
esac

cat > "$source_dir/.builder-target" <<EOF
TARGET=$target
SUBTARGET=$subtarget
PROFILE=$profile
ARCHITECTURE=$architecture
ARCH_PACKAGES=$arch_packages
EOF

echo "Configured $target/$subtarget/$profile ($architecture, $arch_packages)"
