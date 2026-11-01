#!/usr/bin/env python3
"""Parse the repository's firmware build Issue Form into Actions outputs."""

from __future__ import annotations

import os
import re
import sys


TITLE_PREFIX = "[Firmware Build]"
FIELD_LABELS = {
    "Upstream ref": "upstream_ref",
    "Upstream ref override": "upstream_ref_override",
    "Architecture": "architecture",
    "Target": "target",
    "Subtarget": "subtarget",
    "Profile": "profile",
}
OPTIONAL_FIELDS = frozenset({"upstream_ref_override"})
REQUIRED_FIELDS = ("upstream_ref", "architecture", "target", "subtarget", "profile")
COMPONENT_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9_.+-]*$")
REF_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._/+-]{0,199}$")
HEADING_RE = re.compile(r"^### ([^\r\n]+)\r?\n(.*?)(?=^### |\Z)", re.MULTILINE | re.DOTALL)


def fail(message: str) -> None:
    print(f"Invalid firmware build issue: {message}", file=sys.stderr)
    raise SystemExit(2)


def parse_fields(body: str) -> dict[str, str]:
    values: dict[str, str] = {}
    for match in HEADING_RE.finditer(body):
        label = match.group(1).strip()
        if label not in FIELD_LABELS:
            continue
        key = FIELD_LABELS[label]
        if key in values:
            fail(f"duplicate field: {label}")
        value = match.group(2).strip()
        if not value or value == "_No response_":
            if key not in OPTIONAL_FIELDS:
                fail(f"missing field: {label}")
            continue
        if "\n" in value or "\r" in value:
            fail(f"field must contain one line: {label}")
        values[key] = value

    absent = [field for field in REQUIRED_FIELDS if field not in values]
    if absent:
        labels = [label for label, key in FIELD_LABELS.items() if key in absent]
        fail("missing fields: " + ", ".join(labels))
    return values


def validate_ref(ref: str, label: str) -> None:
    if not REF_RE.fullmatch(ref):
        fail(f"{label} contains unsupported characters or is too long")
    if any(part in ref for part in ("..", "//", "@{")) or ref.endswith(("/", ".")):
        fail(f"{label} is not a valid branch, tag, or commit name")


def validate(values: dict[str, str]) -> None:
    if values["architecture"] not in {"mipsel", "arm", "x86"}:
        fail("Architecture must be mipsel, arm, or x86")

    for key in ("target", "subtarget", "profile"):
        if not COMPONENT_RE.fullmatch(values[key]):
            fail(f"invalid {key}: {values[key]!r}")

    validate_ref(values["upstream_ref"], "Upstream ref")
    override = values.get("upstream_ref_override")
    if override is not None:
        validate_ref(override, "Upstream ref override")


def write_outputs(values: dict[str, str]) -> None:
    output_path = os.environ.get("GITHUB_OUTPUT")
    if not output_path:
        fail("GITHUB_OUTPUT is unavailable")
    resolved = values.get("upstream_ref_override") or values["upstream_ref"]
    with open(output_path, "a", encoding="utf-8", newline="\n") as output:
        for key in REQUIRED_FIELDS:
            output.write(f"{key}={resolved if key == 'upstream_ref' else values[key]}\n")


def main() -> None:
    title = os.environ.get("ISSUE_TITLE", "")
    body = os.environ.get("ISSUE_BODY", "")
    if not title.startswith(TITLE_PREFIX):
        fail(f"title must start with {TITLE_PREFIX}")
    if len(body) > 16_384:
        fail("issue body is too long")
    values = parse_fields(body)
    validate(values)
    write_outputs(values)


if __name__ == "__main__":
    main()
