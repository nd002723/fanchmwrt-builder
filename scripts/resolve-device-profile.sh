#!/usr/bin/env bash
set -euo pipefail

source_dir="${1:-}"
target="${2:-}"
subtarget="${3:-}"
profile="${4:-}"
architecture="${5:-}"
backport_source="${6:-${DEVICE_BACKPORT_REPOSITORY:-nd002723/fanchmwrt-device-backports}}"
backport_ref="${7:-${DEVICE_BACKPORT_REF:-}}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
validator="$script_dir/validate-openwrt-target.sh"

if [[ -z "$source_dir" || -z "$target" || -z "$subtarget" ||
	-z "$profile" || -z "$architecture" ]]; then
	echo "Usage: $0 <source> <target> <subtarget> <profile> <architecture> [backport-repository-or-directory] [backport-ref]" >&2
	exit 2
fi

set +e
"$validator" "$source_dir" "$target" "$subtarget" "$profile" "$architecture"
validation_status=$?
set -e
if (( validation_status == 0 )); then
	echo "Using native FanchmWrt device profile"
	exit 0
fi

case "$validation_status" in
	10|11|12) ;;
	*)
		echo "Refusing backport fallback for validation status $validation_status" >&2
		exit "$validation_status"
		;;
esac

cleanup_dir=""
if [[ -d "$backport_source" ]]; then
	backport_dir="$(cd "$backport_source" && pwd)"
else
	if [[ ! "$backport_source" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
		echo "Invalid device backport repository: $backport_source" >&2
		exit 2
	fi
	if [[ -n "$backport_ref" ]] &&
		[[ ! "$backport_ref" =~ ^[A-Za-z0-9][A-Za-z0-9._/-]*$ ]]; then
		echo "Invalid device backport ref: $backport_ref" >&2
		exit 2
	fi

	cleanup_dir="$(mktemp -d)"
	backport_dir="$cleanup_dir/repository"
	mkdir -p "$backport_dir"
	git -C "$backport_dir" init -q
	git -C "$backport_dir" remote add origin \
		"https://github.com/${backport_source}.git"

	default_backport_ref() {
		GIT_TERMINAL_PROMPT=0 git -C "$backport_dir" ls-remote --symref origin HEAD 2>/dev/null \
			| awk '/^ref:/ {sub("refs/heads/", "", $2); print $2; exit}'
	}

	if [[ -z "$backport_ref" ]]; then
		backport_ref="$(default_backport_ref)"
		if [[ -z "$backport_ref" ]]; then
			echo "Cannot resolve the default branch of $backport_source" >&2
			rm -rf -- "$cleanup_dir"
			exit 20
		fi
	fi

	if ! GIT_TERMINAL_PROMPT=0 git -C "$backport_dir" fetch \
		--quiet --depth=1 origin "$backport_ref"; then
		fallback_ref="$(default_backport_ref)"
		if [[ -z "$fallback_ref" || "$fallback_ref" == "$backport_ref" ]]; then
			echo "Required device backport repository is unavailable: $backport_source@$backport_ref" >&2
			rm -rf -- "$cleanup_dir"
			exit 20
		fi
		echo "Device backport ref '$backport_ref' is unavailable, falling back to $fallback_ref" >&2
		backport_ref="$fallback_ref"
		if ! GIT_TERMINAL_PROMPT=0 git -C "$backport_dir" fetch \
			--quiet --depth=1 origin "$backport_ref"; then
			echo "Required device backport repository is unavailable: $backport_source@$backport_ref" >&2
			rm -rf -- "$cleanup_dir"
			exit 20
		fi
	fi
	git -C "$backport_dir" checkout --quiet --detach FETCH_HEAD
fi
trap '[[ -z "$cleanup_dir" ]] || rm -rf -- "$cleanup_dir"' EXIT

apply_script="$backport_dir/scripts/apply.sh"
if [[ ! -f "$apply_script" ]]; then
	echo "Device backport repository does not provide scripts/apply.sh" >&2
	exit 20
fi

bash "$apply_script" "$source_dir"
if ! "$validator" "$source_dir" "$target" "$subtarget" "$profile" "$architecture"; then
	echo "Requested profile is absent after applying the device backports" >&2
	exit 21
fi

echo "Using device profile supplied by $backport_source@$backport_ref"
