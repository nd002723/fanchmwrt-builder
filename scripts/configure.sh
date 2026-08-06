#!/usr/bin/env bash
set -euo pipefail

source_dir="${1:-}"
config_file="${2:-}"

if [[ -z "$source_dir" || -z "$config_file" ]]; then
	echo "Usage: $0 <source-directory> <config-fragment>" >&2
	exit 2
fi

source_dir="$(cd "$source_dir" && pwd)"
config_file="$(cd "$(dirname "$config_file")" && pwd)/$(basename "$config_file")"
cp "$config_file" "$source_dir/.config"
make -C "$source_dir" defconfig

