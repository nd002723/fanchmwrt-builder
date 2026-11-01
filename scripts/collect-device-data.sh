#!/usr/bin/env bash
set -euo pipefail

# Enumerate the device profiles an upstream checkout can build.
#
# Usage: collect-device-data.sh <source-dir> <out-tsv>
#
# The output is a tab separated file of
#   target <TAB> subtarget <TAB> arch_packages <TAB> profile <TAB> titles <TAB> source
# where source is the value passed with --source (default: native).

source_dir="${1:-}"
out_file="${2:-}"
source_label="${3:-native}"

if [[ -z "$source_dir" || -z "$out_file" ]]; then
	echo "Usage: $0 <source-dir> <out-tsv> [source-label]" >&2
	exit 2
fi

if [[ ! -f "$source_dir/scripts/dump-target-info.pl" ]]; then
	echo "Not a FanchmWrt/OpenWrt checkout: $source_dir" >&2
	exit 2
fi

source_dir="$(cd "$source_dir" && pwd)"

# Resolve the output path before changing directory, so a relative argument still
# refers to the caller's working directory.
out_dir="$(dirname "$out_file")"
mkdir -p "$out_dir"
out_file="$(cd "$out_dir" && pwd)/$(basename "$out_file")"

mkdir -p "$source_dir/tmp"

targets_file="$(mktemp)"
trap 'rm -f "$targets_file"' EXIT

cd "$source_dir"
perl scripts/dump-target-info.pl targets 2>/dev/null > "$targets_file" || true

if [[ ! -s "$targets_file" ]]; then
	echo "Could not enumerate upstream targets" >&2
	exit 1
fi

: > "$out_file"
while read -r pair arch_packages; do
	[[ -n "${pair:-}" ]] || continue
	case "$arch_packages" in
		mipsel*|arm*|aarch64*|i386*|x86_64*) ;;
		*) continue ;;
	esac
	perl scripts/dump-target-info.pl devices "$pair" 2>/dev/null |
		while IFS= read -r line; do
			[[ -n "$line" ]] || continue
			profile="${line%% *}"
			titles="${line#* }"
			printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
				"${pair%%/*}" "${pair##*/}" "$arch_packages" "$profile" "$titles" "$source_label" \
				>> "$out_file"
		done
done < "$targets_file"

if [[ ! -s "$out_file" ]]; then
	echo "No device profile was enumerated from $source_dir" >&2
	exit 1
fi

printf 'Enumerated %s device profiles into %s\n' "$(wc -l < "$out_file")" "$out_file"
