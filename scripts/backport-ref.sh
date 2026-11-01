#!/usr/bin/env bash
set -euo pipefail

# Resolve the device backport ref a build should ask for.
#
# Usage: backport-ref.sh <requested> <selection> <override> <fallback>
#
# The four arguments are candidates in priority order and may each be empty:
#
#   requested   DEVICE_BACKPORT_REF, the repository variable an owner pins
#   selection   the release the request selected (this is what a review and the
#               build it dispatches must agree on)
#   override    the free-form `upstream_ref_override` text of a manual dispatch
#   fallback    the dropdown value of a manual dispatch
#
# Only the first usable candidate is printed. A `fanchmwrt-<version>` name is the
# builder-side maintenance branch and the backport repository has no branch under
# that name, so it is rewritten to the release tag its branches are named after.
# Anything that cannot be a branch or tag name is skipped, and an empty result
# means "let resolve-device-profile.sh discover the repository default branch".
#
# Every caller shares this file so a review cannot validate one patch set while
# the build that follows it applies another.

normalize() {
	local ref="$1"
	if [[ -z "$ref" ]]; then
		return 0
	fi
	if [[ "$ref" == fanchmwrt-* ]]; then
		ref="v${ref#fanchmwrt-}"
	fi
	case "$ref" in
		# Not a branch or tag name: give up on this candidate.
		""|*[!A-Za-z0-9._/-]*|@*|*/|*..*) return 0 ;;
	esac
	printf '%s\n' "$ref"
}

for candidate in "$@"; do
	if ref="$(normalize "$candidate")" && [[ -n "$ref" ]]; then
		printf '%s\n' "$ref"
		exit 0
	fi
done

exit 0
