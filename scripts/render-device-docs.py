#!/usr/bin/env python3
"""Render the per-architecture device lists that back the Issue Form fields.

Input is a normalized tab separated file with the columns

    target  subtarget  arch_packages  profile  titles  source

produced from an upstream checkout with ``scripts/dump-target-info.pl devices``
(``titles`` keeps the upstream quoting, ``source`` is ``native`` or ``backport``).
The optional alias file maps a profile to a commonly used name; profiles without
a curated alias keep their upstream model name.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ARCH_FAMILIES = (
    ("mipsel", "mipsel", "mipsel"),
    ("arm", "arm", "arm"),
    ("x86", "x86", "x86"),
)
QUOTED_RE = re.compile(r'"([^"]*)"')
DIGITS_RE = re.compile(r"(\d+)")


def fail(message: str) -> None:
    print(f"Cannot render device lists: {message}", file=sys.stderr)
    raise SystemExit(2)


def family_of(arch_packages: str) -> str | None:
    if arch_packages.startswith("mipsel"):
        return "mipsel"
    if arch_packages.startswith(("arm", "aarch64")):
        return "arm"
    if arch_packages.startswith(("i386", "x86_64")):
        return "x86"
    return None


def clean_titles(raw: str) -> str:
    titles = [title.strip() for title in QUOTED_RE.findall(raw) if title.strip()]
    if not titles:
        titles = [raw.strip()] if raw.strip() else []
    return " / ".join(titles)


def sort_key(title: str) -> list[tuple[int, object]]:
    """Case-insensitive natural order: letters first, then digits."""
    key: list[tuple[int, object]] = []
    for chunk in re.split(r"([0-9]+)", title.casefold()):
        if not chunk:
            continue
        key.append((1, int(chunk)) if chunk.isdigit() else (0, chunk))
    return key


def load_devices(path: Path) -> dict[tuple[str, str, str], dict[str, str]]:
    devices: dict[tuple[str, str, str], dict[str, str]] = {}
    for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if not line.strip():
            continue
        parts = line.split("\t")
        if len(parts) != 6:
            fail(f"{path}:{number}: expected 6 tab separated columns, found {len(parts)}")
        target, subtarget, arch, profile, titles, source = parts
        if source not in {"native", "backport"}:
            fail(f"{path}:{number}: unsupported source {source!r}")
        family = family_of(arch)
        if family is None:
            continue
        devices[(target, subtarget, profile)] = {
            "target": target,
            "subtarget": subtarget,
            "arch": arch,
            "family": family,
            "profile": profile,
            "model": clean_titles(titles),
            "source": source,
        }
    return devices


def load_aliases(path: Path | None) -> dict[str, str]:
    if path is None:
        return {}
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError) as error:
        fail(f"cannot read aliases from {path}: {error}")
    if not isinstance(payload, dict) or not all(
        isinstance(key, str) and isinstance(value, str) for key, value in payload.items()
    ):
        fail(f"{path} must be a JSON object of profile -> name")
    return payload


def render(
    family: str,
    rows: list[dict[str, str]],
    aliases: dict[str, str],
    version: str,
    backport: dict[str, str],
    recommended_ref: str,
) -> str:
    rows = sorted(rows, key=lambda row: (sort_key(row["model"]), row["profile"]))
    aliased = sum(1 for row in rows if row["profile"] in aliases)
    backports = sum(1 for row in rows if row["source"] == "backport")
    parents = sorted({(row["target"], row["subtarget"]) for row in rows})

    lines = [
        f"# {family} 设备列表（FanchmWrt {version}）",
        "",
        f"用于 `Firmware build` 申请的 `target` / `subtarget` / `profile` 三个字段，`architecture` 选 `{family}`。",
        "",
        f"- 枚举到 **{len(rows)}** 个 profile，仅供参考：上游仓库 {len(rows) - backports}，扩展设备仓库 {backports}",
        f"- 已标注常用名：**{aliased}**，其余保留上游原名",
        f"- 涉及 target/subtarget：{len(parents)} 组",
        "- 排序：按设备型号字母/数字顺序（a–z、0–9），常用名不参与排序",
        "- 权威来源是上游仓库：扩展仓库与上游重合时，一律以上游仓库的版本为准",
        "- 本表由 `.github/workflows/sync-upstream-refs.yml` 每天随上游版本自动重新生成，无需手工维护",
        "",
        "## 数据来源",
        "",
        f"- 上游型号：`fanchmwrt/fanchmwrt` 标签 `{version}`，由 `scripts/dump-target-info.pl devices` 枚举，是本表的权威来源",
        f"- 扩展型号：`{backport['repository']}`（{backport['patches']} 个补丁，基线提交 `{backport['baseline']}`），仅作补充参考",
        "",
        "  两处可能重合，合并时以上游仓库为准：上游已有同名 profile 时，本条只按上游记录，不按扩展计入。",
        "",
        f"  扩展型号直接选 `upstream_ref: {recommended_ref}` 即可：补丁集按版本分分支（`v25.12.6`、`v25.12.4`……，`main` 指向最新），"
        f"基线提交是 `{backport['baseline']}`。所选版本没有同名分支时回落到 `main`；构建若提示基线不匹配，"
        f"把 `upstream_ref_override` 填成上面的基线提交。只是列出未必可用，提交前请先按上方参数试一次。"
        f"\n\n  纯 `{version}` 标签不含私有层（`fwxd`、`luci-app-fwx-*` 应用中心），"
        f"用带 `fanchmwrt-` 前缀的维护分支才能通过构建校验。",
        "",
    ]
    if family != "x86":
        lines += [
            "- x86 只有一个可构建型号 `x86/64/generic`，不单独成文。",
            "",
        ]

    examples = {
        "mipsel": ("ramips", "mt7621", "xiaoyu_xy-c5"),
        "arm": ("rockchip", "armv8", "friendlyarm_nanopi-r5c"),
    }
    example_target, example_subtarget, example_profile = examples.get(
        family, ("x86", "64", "generic")
    )
    lines += [
        "## 填写范例",
        "",
        "```text",
        f"upstream_ref: {recommended_ref}",
        f"architecture: {family}",
        f"target:       {example_target}",
        f"subtarget:    {example_subtarget}",
        f"profile:      {example_profile}",
        "```",
        "",
        "扩展型号的填法与原生型号相同：直接在下拉里选对应版本即可，不用填 override。",
        "补丁集按版本分分支（`v25.12.6`、`v25.12.4`……，`main` 指向最新），基线提交与所选版本不符时会在编译前明确报错。",
        "",
        "## 按 target/subtarget 统计",
        "",
        "| target | subtarget | 设备数 |",
        "| --- | --- | --- |",
    ]
    for parent in parents:
        count = sum(1 for row in rows if (row["target"], row["subtarget"]) == parent)
        lines.append(f"| {parent[0]} | {parent[1]} | {count} |")

    lines += [
        "",
        "## 设备列表",
        "",
        "| 常用名 | 设备型号 | target | subtarget | profile | 来源 |",
        "| --- | --- | --- | --- | --- | --- |",
    ]
    for row in rows:
        common = aliases.get(row["profile"], row["model"])
        source = "原生" if row["source"] == "native" else "扩展"
        name = common.replace("|", "\\|")
        model = row["model"].replace("|", "\\|") or "—"
        lines.append(
            f"| {name} | {model} | {row['target']} | {row['subtarget']} | `{row['profile']}` | {source} |"
        )
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--devices", required=True, help="normalized native device TSV")
    parser.add_argument("--backports", help="normalized TSV of devices added by the backport repository")
    parser.add_argument("--aliases", help="JSON object mapping profile to a common name")
    parser.add_argument("--out-dir", required=True, help="directory receiving devices-<family>.md")
    parser.add_argument("--version", required=True, help="upstream version label, for example v25.12.6")
    parser.add_argument(
        "--backport-repository",
        default="nd002723/fanchmwrt-device-backports",
        help="repository that supplies the optional device backports",
    )
    parser.add_argument("--backport-baseline", default="unknown", help="FanchmWrt commit the patches require")
    parser.add_argument("--backport-patches", default="0", help="number of patches in the backport set")
    parser.add_argument(
        "--recommended-ref",
        help="ref the docs tell users to select; defaults to --version",
    )
    args = parser.parse_args()

    native = load_devices(Path(args.devices))
    if not native:
        fail("the device TSV contains no supported device")

    # The upstream repository stays authoritative: a profile that upstream already
    # ships is recorded once, as native, even when the backport set adds it too.
    merged = dict(native)
    if args.backports:
        for key, row in load_devices(Path(args.backports)).items():
            if key in merged:
                continue
            merged[key] = {**row, "source": "backport"}

    rows = list(merged.values())
    aliases = load_aliases(Path(args.aliases) if args.aliases else None)
    unknown = sorted(set(aliases) - {row["profile"] for row in rows})
    if unknown:
        print(f"warning: alias for unknown profile ignored: {', '.join(unknown)}", file=sys.stderr)

    backport = {
        "repository": args.backport_repository,
        "baseline": args.backport_baseline,
        "patches": args.backport_patches,
    }

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    for family, _, _ in ARCH_FAMILIES:
        if family == "x86":
            continue
        selected = [row for row in rows if row["family"] == family]
        if not selected:
            continue
        path = out_dir / f"devices-{family}.md"
        path.write_text(
            render(
                family,
                selected,
                aliases,
                args.version,
                backport,
                args.recommended_ref or args.version,
            ),
            encoding="utf-8",
        )
        print(f"{path}: {len(selected)} devices")


if __name__ == "__main__":
    main()
