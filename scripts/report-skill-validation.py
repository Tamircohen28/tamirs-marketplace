#!/usr/bin/env python3
"""Pretty-print a `claude plugin validate --json` report (Claude Code 2.1.259+).

Reads the JSON validation report from stdin (or a file path given as argv[1])
and prints a compact pass/fail summary plus any per-file errors/warnings.
Exits 0 if the report's "success" field is true, 1 otherwise, so it can sit
at the end of a shell pipeline as `make validate-skills`'s exit status.

Before 2.1.259, `claude plugin validate` only had human-readable text output,
so `make validate-skills` relied on the CLI's own process exit code. `--json`
gives a machine-readable report instead — this script is what turns that
report back into a readable summary for a terminal, while also being the
shape a future CI job could consume directly (see docs/agent-guidelines/
testing.md for why that job isn't wired into CI yet).
"""
from __future__ import annotations

import json
import sys


def main() -> int:
    raw = sys.stdin.read() if len(sys.argv) < 2 else open(sys.argv[1], encoding="utf-8").read()
    try:
        report = json.loads(raw)
    except json.JSONDecodeError as exc:
        print(f"error: could not parse validation report as JSON: {exc}", file=sys.stderr)
        print(raw, file=sys.stderr)
        return 1

    # `contents` lists only files with something to report (errors/warnings/notes),
    # not every file scanned — so this is a findings count, not a coverage count.
    contents = report.get("contents", [])
    status = "PASS" if report.get("success") else "FAIL"
    print(f"skill validation: {status} ({len(contents)} file(s) with findings, strict={report.get('strict')})")

    for entry in contents:
        errors = entry.get("errors", [])
        warnings = entry.get("warnings", [])
        if not errors and not warnings:
            continue
        print(f"  {entry.get('file')}:")
        for err in errors:
            print(f"    error: {err.get('message', err)}")
        for warn in warnings:
            print(f"    warning: {warn.get('message', warn)}")

    return 0 if report.get("success") else 1


if __name__ == "__main__":
    raise SystemExit(main())
