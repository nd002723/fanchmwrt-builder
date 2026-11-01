#!/usr/bin/env bash
set -euo pipefail

# Resolve one device profile, upstream first.
#
#   1. FanchmWrt native: the requested target/subtarget/profile is already in the
#      upstream checkout. Nothing is downloaded and no patch is applied.
#   2. Device backports: upstream lacks the profile, so the optional patch set is
#      fetched and applied, then the same target information is consulted again.
#   3. Not found anywhere: report the profile as unknown and stop before any
#      compile begins. This is the original "device not detected" outcome, and it
#      is what the request pipeline turns into a rejection.
#
# Exit codes:
#   0   profile available, either natively or via the backport set
#   2   bad invocation (invalid repository, ref, or arguments)
#   21  profile absent from both sources -- the not-found outcome
#   other statuses come from validate-openwrt-target.sh and are *not* recoverable
#   by the backport set (an architecture mismatch stays a mismatch).

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

requested="$target/$subtarget/$profile"

# Final step of the chain: neither source can produce this profile.
not_found() {
	local reason="$1"
	cat >&2 <<-EOF
	Cannot resolve device profile: $requested
	  architecture:  $architecture
	  upstream:      profile is not provided by this FanchmWrt release
	  device backports: $reason
	Use an OpenWrt target, subtarget and profile name that this release supports,
	or switch to a version whose device backport set carries the profile.
	EOF
	exit 21
}

# --- 1. upstream -------------------------------------------------------------
set +e
"$validator" "$source_dir" "$target" "$subtarget" "$profile" "$architecture"
validation_status=$?
set -e
if (( validation_status == 0 )); then
	echo "Using native FanchmWrt device profile"
	exit 0
fi

# Only "the profile is missing from this tree" may reach for the backport set.
# An architecture mismatch or an unparsable target is a request error, and a
# patch series cannot repair it.
case "$validation_status" in
	10|11|12) ;;
	*)
		echo "Refusing backport fallback for validation status $validation_status" >&2
		exit "$validation_status"
		;;
esac

echo "Upstream does not provide $requested; checking the device backports"

# --- 2. device backports -----------------------------------------------------
cleanup_dir=""
if [[ -d "$backport_source" ]]; then
	backport_dir="$(cd "$backport_source" && pwd)"
	# A local checkout is used exactly as it stands, so a requested ref cannot be
	# honoured. Report what is really there instead of echoing a ref that was not
	# used -- the log used to claim `@v25.12.4` while applying the checked-out
	# v25.12.6 series.
	resolved_ref="$(git -C "$backport_dir" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
	if [[ -z "$resolved_ref" || "$resolved_ref" == "HEAD" ]]; then
		resolved_ref="$(git -C "$backport_dir" rev-parse --short HEAD 2>/dev/null || echo 'local checkout')"
	fi
	backport_ref="$resolved_ref"
	echo "Using the local device backport checkout at $backport_dir ($backport_ref)"
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
			not_found "the repository $backport_source could not be reached"
		fi
	fi

	if ! GIT_TERMINAL_PROMPT=0 git -C "$backport_dir" fetch \
		--quiet --depth=1 origin "$backport_ref"; then
		fallback_ref="$(default_backport_ref)"
		if [[ -z "$fallback_ref" || "$fallback_ref" == "$backport_ref" ]]; then
			not_found "the repository $backport_source has no ref $backport_ref"
		fi
		echo "Device backport ref '$backport_ref' is unavailable, falling back to $fallback_ref" >&2
		backport_ref="$fallback_ref"
		if ! GIT_TERMINAL_PROMPT=0 git -C "$backport_dir" fetch \
			--quiet --depth=1 origin "$backport_ref"; then
			not_found "the repository $backport_source could not be fetched"
		fi
	fi
	git -C "$backport_dir" checkout --quiet --detach FETCH_HEAD
fi
trap '[[ -z "$cleanup_dir" ]] || rm -rf -- "$cleanup_dir"' EXIT

apply_script="$backport_dir/scripts/apply.sh"
if [[ ! -f "$apply_script" ]]; then
	not_found "the repository at $backport_source provides no scripts/apply.sh"
fi

# The series is pinned to one release and refuses a checkout it was not written
# for. That is a reason this profile stays unavailable, not a build failure, so
# it ends in the same not-found outcome with the pin spelled out.
set +e
apply_output="$(bash "$apply_script" "$source_dir" 2>&1)"
apply_status=$?
set -e
printf '%s\n' "$apply_output"
if (( apply_status != 0 )); then
	# Carry the patch set's own explanation into the not-found report: "requires
	# <sha>" and "the clone is too shallow" tell the requester what to change,
	# where a bare patch-count mismatch would not.
	pin="$(printf '%s\n' "$apply_output" \
		| grep -E '^This patch set requires|^  required base:|^Patch count mismatch|^Cannot verify the FanchmWrt source revision' \
		| head -n 2 | tr -s ' ' | paste -sd ';' - || true)"
	not_found "the patch set does not apply to this release${pin:+ ($pin)}"
fi

if ! "$validator" "$source_dir" "$target" "$subtarget" "$profile" "$architecture"; then
	not_found "the patch set applies but does not add this profile"
fi

echo "Using device profile supplied by $backport_source@$backport_ref"
