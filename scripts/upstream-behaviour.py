#!/usr/bin/env python3
"""Report the behaviour upstream declared for one release.

Reads the mirror of ``manifest.json`` that ``sync-upstream-refs.yml`` writes to
``.github/upstream-manifest.json`` and prints the behaviour attached to the given
version. Upstream is authoritative, so a release that announces a repair can
withdraw the maintenance claim of an older version instead of this repository
having to carry that rule as code.

    {"maintenance": {"v25.12.6": "silent"}}

Prints ``normal`` when the version is unknown, when the file is missing, or when
the entry carries no usable behaviour, so a repository without a manifest keeps
working exactly as before.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

BEHAVIOURS = ("normal", "maintenance", "silent")


def behaviour(manifest: Path, version: str) -> str:
    try:
        payload = json.loads(manifest.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return "normal"
    if not isinstance(payload, dict):
        return "normal"
    table = payload.get("maintenance")
    if not isinstance(table, dict):
        return "normal"
    entry = table.get(version)
    if isinstance(entry, str) and entry in BEHAVIOURS:
        return entry
    if isinstance(entry, dict):
        value = entry.get("behaviour")
        if isinstance(value, str) and value in BEHAVIOURS:
            return value
    return "normal"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("version", help="release tag, for example v25.12.7")
    parser.add_argument(
        "--manifest",
        default=".github/upstream-manifest.json",
        help="mirror of the upstream manifest (default: .github/upstream-manifest.json)",
    )
    args = parser.parse_args()
    print(behaviour(Path(args.manifest), args.version))


if __name__ == "__main__":
    main()
