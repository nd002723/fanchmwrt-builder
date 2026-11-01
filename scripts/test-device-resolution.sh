#!/usr/bin/env bash
set -euo pipefail

# Offline test of the three-stage device resolution in
# scripts/resolve-device-profile.sh.
#
#   1. upstream provides the profile            -> native, nothing applied
#   2. upstream lacks it, backports provide it  -> backports applied, status 0
#   3. neither source provides it               -> status 21 (not found)
#
# The upstream tree and the backport repository are replaced by stubs, so this
# runs without a checkout, a network or a compiler. What is under test is the
# order and the exit codes: a request must never be reported as a build failure
# when the only problem is that no source knows the device.
#
# Usage: bash scripts/test-device-resolution.sh

builder_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
resolver="$builder_root/scripts/resolve-device-profile.sh"

[[ -f "$resolver" ]] || { echo "Missing script: $resolver" >&2; exit 2; }

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

failures=0
pass() { printf 'ok   %s\n' "$1"; }
fail_case() { printf 'FAIL %s\n' "$1"; failures=$((failures + 1)); }

# Upstream stub: the validator needs a target Makefile, the dump script, and a
# `make` that answers the target-info query.
make_upstream() {
	local dir="$1"
	mkdir -p "$dir/target/linux/ramips" "$dir/scripts" "$dir/bin"
	printf 'include $(TOPDIR)/rules.mk\n' > "$dir/target/linux/ramips/Makefile"
	# The device list is the native list plus whatever the backport stub adds to
	# the checkout during the run, which is how the real tree grows when the
	# series adds board files.
	cat > "$dir/scripts/dump-target-info.pl" <<'PERL'
#!/usr/bin/env perl
use strict;
my ($command) = @ARGV;
if ($command eq 'devices') {
	my @devices = split /\n/, $ENV{STUB_DEVICES};
	if ($ENV{STUB_EXTRA} && -e $ENV{STUB_EXTRA}) {
		open my $handle, '<', $ENV{STUB_EXTRA} or die "$ENV{STUB_EXTRA}: $!";
		chomp(my @added = <$handle>);
		close $handle;
		push @devices, @added;
	}
	for my $line (grep { length } @devices) {
		print "$line\t\"$line model\"\n";
	}
}
PERL
	chmod +x "$dir/scripts/dump-target-info.pl"
	cat > "$dir/bin/make" <<'SH'
#!/usr/bin/env bash
printf '%s\n' 'Target: ramips/mt7621' 'Target-Arch-Packages: mipsel_24kc'
SH
	chmod +x "$dir/bin/make"
	printf '%s\n' xiaoyu_xy-c5 native_only > "$dir/native-devices"
}

# Backport stub: appends its profiles to the checkout it is handed, exactly like
# the real series adds board files to the source tree.
make_backports() {
	local dir="$1" status="$2" adds="$3"
	mkdir -p "$dir/scripts"
	{
		echo '#!/usr/bin/env bash'
		echo 'set -euo pipefail'
		echo 'echo "applying stub backports"'
		if [[ "$status" != "0" ]]; then
			echo 'echo "This patch set requires 0123456789abcdef0123456789abcdef01234567" >&2'
			echo 'exit 1'
		else
			printf 'printf "%%s\\n" "%s" > "$1/.added-devices"\n' "$adds"
		fi
	} > "$dir/scripts/apply.sh"
	chmod +x "$dir/scripts/apply.sh"
}

# Run the resolver against a pristine upstream stub. The backport stub may add
# profiles to that stub during the run, which is how stage 2 is detected.
resolve() {
	local profile="$1" backports="$2" arch="${3:-mipsel}"
	local upstream="$work_dir/upstream-$RANDOM"
	make_upstream "$upstream"
	# The stub `make` has to answer the validator's target query; without it the
	# real make runs and every case collapses into "target could not be loaded".
	STUB_DEVICES="$(cat "$upstream/native-devices")" \
	STUB_EXTRA="$upstream/.added-devices" \
	PATH="$upstream/bin:$PATH" \
		bash "$resolver" "$upstream" ramips mt7621 "$profile" "$arch" "$backports" \
		>"$work_dir/log" 2>&1
}

status_of() {
	local actual=0
	"$@" || actual=$?
	printf '%s' "$actual"
}

ok_backports="$work_dir/backports"
make_backports "$ok_backports" 0 backport_only

failing_backports="$work_dir/failing-backports"
make_backports "$failing_backports" 1 ""

bare_backports="$work_dir/bare-backports"
mkdir -p "$bare_backports"

# --- 1. upstream -------------------------------------------------------------
if [[ "$(status_of resolve xiaoyu_xy-c5 "$ok_backports")" == "0" ]] &&
	grep -q "Using native FanchmWrt device profile" "$work_dir/log"; then
	pass "a native profile is resolved without the backports"
else
	fail_case "a native profile is resolved without the backports"
fi

if ! grep -q "checking the device backports" "$work_dir/log"; then
	pass "the native path never reaches for the backport set"
else
	fail_case "the native path never reaches for the backport set"
fi

# --- 2. backports ------------------------------------------------------------
if [[ "$(status_of resolve backport_only "$ok_backports")" == "0" ]] &&
	grep -q "Using device profile supplied by" "$work_dir/log"; then
	pass "a profile only the backports provide is accepted"
else
	fail_case "a profile only the backports provide is accepted"
fi

if grep -q "Upstream does not provide ramips/mt7621/backport_only" "$work_dir/log"; then
	pass "the backport path records that upstream came first"
else
	fail_case "the backport path records that upstream came first"
fi

# --- 3. not found anywhere ---------------------------------------------------
if [[ "$(status_of resolve absent_everywhere "$ok_backports")" == "21" ]]; then
	pass "a profile neither source provides reports not-found (exit 21)"
else
	fail_case "a profile neither source provides reports not-found (exit 21)"
fi

if grep -q "Cannot resolve device profile: ramips/mt7621/absent_everywhere" "$work_dir/log"; then
	pass "the not-found report names the requested profile"
else
	fail_case "the not-found report names the requested profile"
fi

if grep -q "device backports: the patch set applies but does not add this profile" "$work_dir/log"; then
	pass "the not-found report states what each source did"
else
	fail_case "the not-found report states what each source did"
fi

if [[ "$(status_of resolve backport_only "$failing_backports")" == "21" ]]; then
	pass "a patch set that does not apply also ends as not-found"
else
	fail_case "a patch set that does not apply also ends as not-found"
fi

if grep -q "the patch set does not apply to this release" "$work_dir/log" &&
	grep -q "0123456789abcdef" "$work_dir/log"; then
	pass "the not-found report carries the patch set's own explanation"
else
	fail_case "the not-found report carries the patch set's own explanation"
fi

if [[ "$(status_of resolve backport_only "$bare_backports")" == "21" ]] &&
	grep -q "provides no scripts/apply.sh" "$work_dir/log"; then
	pass "a backport source without apply.sh also ends as not-found"
else
	fail_case "a backport source without apply.sh also ends as not-found"
fi

# --- 4. not a device problem -------------------------------------------------
# An architecture mismatch cannot be repaired by a patch set, so it must keep
# the validator's status instead of turning into "device not found".
if [[ "$(status_of resolve xiaoyu_xy-c5 "$ok_backports" arm)" == "13" ]]; then
	pass "an architecture mismatch keeps the validator's status"
else
	fail_case "an architecture mismatch keeps the validator's status"
fi

if (( failures > 0 )); then
	printf '\n%d test(s) failed\n' "$failures" >&2
	exit 1
fi
printf '\nAll device resolution tests passed\n'
