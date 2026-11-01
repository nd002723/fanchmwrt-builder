#!/usr/bin/env python3
"""Check the contracts the workflows share with each other and with the scripts.

Every rule here is a bug this repository already shipped once:

* a job that `require()`s a local module without checking out the repository
  (the module resolves against the workspace, so the job dies before it works);
* a `github-script` block that calls a label helper it never imported;
* a `needs.<job>.outputs.<name>` that the job does not declare;
* a reusable workflow call that omits a required input;
* a `require('./scripts/...')` pointing at a file that is not there.

PyYAML reads `on` as the boolean key `True`, so both spellings are consulted.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
WORKFLOW_DIR = ROOT / ".github" / "workflows"

failures: list[str] = []


def report(ok: bool, name: str, detail: str = "") -> None:
    if ok:
        print(f"ok   {name}")
    else:
        print(f"FAIL {name}{f': {detail}' if detail else ''}")
        failures.append(name)


def load_workflow(path: Path) -> dict:
    data = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    if not isinstance(data, dict):
        raise SystemExit(f"{path} is not a workflow document")
    return data


def trigger_block(workflow: dict, name: str) -> dict | None:
    on = workflow.get("on")
    if on is None:
        on = workflow.get(True)  # PyYAML reads a bare `on:` as the boolean key.
    if not isinstance(on, dict):
        return None
    block = on.get(name)
    return block if isinstance(block, dict) else None


def strings(value) -> list[str]:
    if isinstance(value, str):
        return [value]
    if isinstance(value, dict):
        return [text for item in value.values() for text in strings(item)]
    if isinstance(value, list):
        return [text for item in value for text in strings(item)]
    return []


def steps_of(job: dict) -> list[dict]:
    steps = job.get("steps")
    if not steps:
        return []
    return [step for step in steps if isinstance(step, dict)]


def script_of(step: dict) -> str:
    with_block = step.get("with")
    if not isinstance(with_block, dict):
        return ""
    script = with_block.get("script")
    return script if isinstance(script, str) else ""


def uses_of(step: dict) -> str:
    uses = step.get("uses")
    return uses if isinstance(uses, str) else ""


def local_workflow(uses: str) -> Path | None:
    if not uses.startswith("./.github/workflows/"):
        return None
    return ROOT / uses[2:]


def callee_outputs(uses: str) -> dict:
    path = local_workflow(uses)
    if path is None or not path.exists():
        return {}
    workflow = load_workflow(path)
    call = trigger_block(workflow, "workflow_call") or {}
    outputs = call.get("outputs")
    return outputs if isinstance(outputs, dict) else {}


def callee_inputs(uses: str) -> dict:
    path = local_workflow(uses)
    if path is None or not path.exists():
        return {}
    workflow = load_workflow(path)
    call = trigger_block(workflow, "workflow_call") or {}
    inputs = call.get("inputs")
    return inputs if isinstance(inputs, dict) else {}



def execution_checks() -> None:
    """Run the ref-derivation step of build.yml the way the runner would.

    This is the only way to catch a wrong candidate order: the step reads its
    arguments from env, so reading the YAML cannot tell whether a pinned override
    still outranks the dropdown selection it sits next to.
    """
    import os
    import subprocess
    import tempfile

    workflow = load_workflow(WORKFLOW_DIR / "build.yml")
    steps = workflow.get("jobs", {}).get("build", {}).get("steps", [])
    step = next((item for item in steps if item.get("name") == "Derive device backport ref"), None)
    if step is None:
        report(False, "build.yml keeps a Derive device backport ref step")
        return
    body = step.get("run", "")
    sha = "a" * 40
    cases = [
        (
            "a caller's selected release decides the series when nothing is pinned",
            {"EVENT_NAME": "workflow_call", "SELECTED_NAME": "fanchmwrt-25.12.4", "SELECTED_REF": sha},
            "v25.12.4",
        ),
        (
            "a pinned commit outranks the selected release",
            {"EVENT_NAME": "workflow_call", "SELECTED_NAME": "fanchmwrt-25.12.4", "PINNED_REF": sha, "SELECTED_REF": sha},
            sha,
        ),
        (
            "the repository variable outranks everything",
            {"EVENT_NAME": "workflow_call", "REQUESTED_REF": "fanchmwrt-25.12.3", "PINNED_REF": sha, "SELECTED_NAME": "fanchmwrt-25.12.6"},
            "v25.12.3",
        ),
        (
            "a dispatch override outranks its dropdown",
            {"EVENT_NAME": "workflow_dispatch", "PINNED_REF": "v25.12.5", "SELECTED_REF": "fanchmwrt-25.12.6"},
            "v25.12.5",
        ),
        (
            "a dispatch with a plain dropdown still derives its tag",
            {"EVENT_NAME": "workflow_dispatch", "SELECTED_REF": "fanchmwrt-25.12.6"},
            "v25.12.6",
        ),
        (
            "a caller that names no release asks for the default branch",
            {"EVENT_NAME": "workflow_call", "SELECTED_REF": sha},
            "",
        ),
    ]

    for name, env, expected in cases:
        with tempfile.TemporaryDirectory() as directory:
            output_path = Path(directory) / "github_output"
            output_path.write_text("", encoding="utf-8")
            full_env = {
                key: value
                for key, value in os.environ.items()
                if not key.startswith(("REQUESTED_REF", "SELECTED_", "PINNED_REF", "GITHUB_OUTPUT"))
            }
            full_env.update(env)
            full_env["GITHUB_OUTPUT"] = str(output_path)
            completed = subprocess.run(
                ["bash", "-c", body],
                cwd=ROOT,
                env=full_env,
                capture_output=True,
                text=True,
            )
            produced = ""
            for line in output_path.read_text(encoding="utf-8").splitlines():
                if line.startswith("ref="):
                    produced = line[len("ref="):]
            report(
                completed.returncode == 0 and produced == expected,
                f"the build derives the backport ref: {name}",
                f"expected {expected!r}, got {produced!r} (rc={completed.returncode}) {completed.stderr.strip()[:200]}",
            )

def main() -> int:
    workflows = {path.name: load_workflow(path) for path in sorted(WORKFLOW_DIR.glob("*.yml"))}
    report(bool(workflows), "every workflow in .github/workflows is readable", "no workflow found")

    for name, workflow in workflows.items():
        jobs = workflow.get("jobs")
        jobs = jobs if isinstance(jobs, dict) else {}

        for job_name, job in jobs.items():
            job = job if isinstance(job, dict) else {}
            label = f"{name}:{job_name}"
            steps = steps_of(job)

            # 1. A local require resolves against the workspace, so the job has to
            #    check the repository out before the first script runs.
            checked_out = False
            for step in steps:
                script = script_of(step)
                if script and "require('./scripts" in script:
                    report(
                        checked_out,
                        f"{label} checks out before requiring a local module",
                        f"step {step.get('name')!r} requires ./scripts without a checkout",
                    )
                if uses_of(step).startswith("actions/checkout"):
                    checked_out = True

            # 2. Label helpers come from one shared table; a call without the
            #    import fails at runtime, not at review time.
            for step in steps:
                script = script_of(step)
                if not re.search(r"\b(ensureLabel|ensureAllLabels)\s*\(", script):
                    continue
                imported = "scripts/lib/labels.js" in script
                defined = re.search(r"function\s+(ensureLabel|ensureAllLabels)\s*\(", script)
                report(
                    imported or bool(defined),
                    f"{label} imports the label helper it calls",
                    f"step {step.get('name')!r} calls a helper it never imported",
                )

            # 3/4. Whole job text: does every referenced needs output exist, does
            #      every local require point at a real file, and are required
            #      reusable-workflow inputs supplied?
            text = "\n".join(strings(job))
            for dependency, output in set(re.findall(r"needs\.([A-Za-z0-9_-]+)\.outputs\.([A-Za-z0-9_]+)", text)):
                target = jobs.get(dependency)
                declared: dict = {}
                if isinstance(target, dict):
                    if isinstance(target.get("outputs"), dict):
                        declared = target["outputs"]
                    elif isinstance(target.get("uses"), str):
                        declared = callee_outputs(target["uses"])
                report(
                    output in declared,
                    f"{label} reads an existing output needs.{dependency}.outputs.{output}",
                    f"needs.{dependency} does not declare {output}",
                )

            for module in set(re.findall(r"require\('\./(scripts/[^']+)'\)", text)):
                report(
                    (ROOT / module).is_file(),
                    f"{label} requires an existing module {module}",
                )

            uses = job.get("uses")
            if isinstance(uses, str) and local_workflow(uses) is not None:
                provided = job.get("with") if isinstance(job.get("with"), dict) else {}
                for input_name, definition in callee_inputs(uses).items():
                    definition = definition if isinstance(definition, dict) else {}
                    requires_value = definition.get("required") is True and "default" not in definition
                    report(
                        input_name in provided or not requires_value,
                        f"{label} supplies the required input {input_name} of {uses}",
                        f"{uses} requires {input_name}",
                    )

    execution_checks()

    if failures:
        print(f"\n{len(failures)} workflow contract(s) broken")
        return 1
    print("\nAll workflow contracts hold")
    return 0


if __name__ == "__main__":
    sys.exit(main())
