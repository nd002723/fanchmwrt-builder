#!/usr/bin/env bash
set -uo pipefail

# Locks the device backport ref rule. Four workflows ask for a patch set, and all
# of them call this script; a review that validates one series while the build
# applies another is exactly the drift this suite prevents.

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
script="$here/backport-ref.sh"
failures=0

check() {
	local name="$1" expected="$2" actual="$3"
	if [[ "$expected" == "$actual" ]]; then
		echo "ok   $name"
	else
		echo "FAIL $name: expected [$expected], got [$actual]"
		failures=$((failures + 1))
	fi
}

check "a maintenance branch is rewritten to its release tag" \
	"v25.12.6" "$(bash "$script" '' 'fanchmwrt-25.12.6' '' '')"
check "an earlier candidate wins over a later one" \
	"v25.12.4" "$(bash "$script" '' 'fanchmwrt-25.12.4' '' 'deadbeef')"
check "a pinned commit outranks the release next to it" \
	"$(printf 'a%.0s' {1..40})" "$(bash "$script" '' "$(printf 'a%.0s' {1..40})" 'fanchmwrt-25.12.4' '')"
check "the repository variable outranks every request argument" \
	"v25.12.3" "$(bash "$script" 'fanchmwrt-25.12.3' 'fanchmwrt-25.12.6' '' '')"
check "the third candidate is used when the first two are empty" \
	"v25.12.5" "$(bash "$script" '' '' 'v25.12.5' 'fanchmwrt-25.12.6')"
check "the last candidate is the final resort" \
	"v25.12.6" "$(bash "$script" '' '' '' 'fanchmwrt-25.12.6')"
check "an unusable candidate is skipped, not fatal" \
	"v25.12.4" "$(bash "$script" 'not a ref' 'v25.12.4' '' '')"
check "nothing usable leaves the ref empty for the resolver" \
	"" "$(bash "$script" '' '' '' '')"
check "path traversal is refused" "" "$(bash "$script" 'v1/../evil' '' '' '')"
check "a ref belonging to another repository is refused" "" "$(bash "$script" 'v25.12.6@x' '' '' '')"
check "a trailing slash is refused" "" "$(bash "$script" 'v25.12.6/' '' '' '')"
check "an already normalised tag passes through" \
	"v25.12.6" "$(bash "$script" 'v25.12.6' '' '' '')"

if ((failures > 0)); then
	echo
	echo "$failures test(s) failed"
	exit 1
fi
echo
echo "All device backport ref tests passed"
