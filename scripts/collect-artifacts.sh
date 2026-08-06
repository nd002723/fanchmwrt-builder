#!/usr/bin/env bash
set -euo pipefail

source_dir="${1:-}"
artifact_dir="${2:-}"
builder_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -z "$source_dir" || -z "$artifact_dir" ]]; then
	echo "Usage: $0 <source-directory> <artifact-directory>" >&2
	exit 2
fi

source_dir="$(cd "$source_dir" && pwd)"
mkdir -p "$artifact_dir"
artifact_dir="$(cd "$artifact_dir" && pwd)"
target_dir="$source_dir/bin/targets/ramips/mt7621"

cp "$source_dir/.config" "$artifact_dir/xiaoyu-xy-c5.config"
for file in sha256sums profiles.json *.buildinfo; do
	for source_file in "$target_dir"/$file; do
		[[ -f "$source_file" ]] || continue
		cp "$source_file" "$artifact_dir/"
	done
done

firmware_found=0
for source_file in "$target_dir"/*xiaoyu_xy-c5*; do
	[[ -f "$source_file" ]] || continue
	cp "$source_file" "$artifact_dir/"
	firmware_found=1
done
(( firmware_found == 1 )) || {
	echo "No Xiaoyu XY-C5 firmware artifacts found" >&2
	exit 1
}

cp "$builder_root/assets/first-extroot-sysupgrade.sh" "$artifact_dir/"
cat > "$artifact_dir/BUILD-METADATA.txt" <<EOF
Builder version: $(tr -d '\r\n' < "$builder_root/VERSION")
Upstream repository: https://github.com/fanchmwrt/fanchmwrt
Upstream commit: $(git -C "$source_dir" rev-parse HEAD)
Build time UTC: $(date -u '+%Y-%m-%dT%H:%M:%SZ')
Target: ramips/mt7621/xiaoyu_xy-c5
EOF

cat > "$artifact_dir/UPGRADE-NOTES.txt" <<'EOF'
Upgrade policy:
- sysupgrade saves changed overlay files and the installed package manifest.
- firmware-owned APK repository files are refreshed from /rom on first boot.
- downloads.openwrt.org is replaced with mirror.nju.edu.cn/openwrt.
- the external /overlay mount is re-enabled before the activation reboot.
- old external upper/work directories are kept until package restoration succeeds.
- packages absent from the new firmware are retained without importing the old APK database.
- the new APK resolver re-registers packages from the new repositories or cached APK files.
- failed migrations retain backups for rollback; successful migrations remove them.
- use first-extroot-sysupgrade.sh for the first upgrade from firmware without this package.
EOF

