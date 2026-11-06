#!/usr/bin/env python3
"""Validate Claude, Codex, and Cursor marketplace manifests stay in sync."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
CLAUDE_MANIFEST = REPO_ROOT / ".claude-plugin" / "marketplace.json"
CODEX_MANIFEST = REPO_ROOT / ".agents" / "plugins" / "marketplace.json"
CURSOR_MANIFEST = REPO_ROOT / ".cursor-plugin" / "marketplace.json"

CURSOR_NAME_PATTERN = re.compile(r"^[a-z0-9]([a-z0-9.-]*[a-z0-9])?$")


def load_json(path: Path) -> dict:
    with path.open(encoding="utf-8") as f:
        return json.load(f)


def plugin_names(manifest: dict) -> list[str]:
    return [entry["name"] for entry in manifest.get("plugins", [])]


def validate_claude(data: dict, errors: list[str]) -> None:
    required = ["name", "version", "description", "owner", "plugins"]
    missing = [key for key in required if key not in data]
    if missing:
        errors.append(f"Claude manifest missing fields: {missing}")

    for entry in data.get("plugins", []):
        for field in ("name", "source", "description"):
            if field not in entry:
                errors.append(f"Claude plugin missing {field!r}: {entry.get('name', entry)}")
        source = entry.get("source", {})
        github_ok = source.get("source") == "github" and source.get("repo")
        url = str(source.get("url", ""))
        url_ok = source.get("source") == "url" and url.startswith("https://github.com/") and url.count("/") >= 4
        if not (github_ok or url_ok):
            errors.append(
                f"Claude plugin {entry.get('name')!r} must use a github source with repo, "
                "or a url source with an https://github.com/ URL"
            )


def validate_codex(data: dict, errors: list[str]) -> None:
    if "name" not in data:
        errors.append("Codex manifest missing name")
    if "plugins" not in data:
        errors.append("Codex manifest missing plugins")

    for entry in data.get("plugins", []):
        name = entry.get("name", "<unknown>")
        policy = entry.get("policy", {})
        for field in ("installation", "authentication"):
            if field not in policy:
                errors.append(f"Codex plugin {name!r} missing policy.{field}")
        if "category" not in entry:
            errors.append(f"Codex plugin {name!r} missing category")

        source = entry.get("source", {})
        if source.get("source") != "url":
            errors.append(f"Codex plugin {name!r} must use url source")
            continue
        url = source.get("url", "")
        if not url.endswith(".git"):
            errors.append(f"Codex plugin {name!r} url must end with .git: {url!r}")


def validate_cursor(data: dict, errors: list[str]) -> None:
    if "name" not in data:
        errors.append("Cursor manifest missing name")
    if "plugins" not in data:
        errors.append("Cursor manifest missing plugins")

    for entry in data.get("plugins", []):
        name = entry.get("name", "<unknown>")
        source = entry.get("source")
        if not isinstance(source, str) or not source.strip():
            errors.append(f"Cursor plugin {name!r} must have non-empty string source")
            continue
        if not (
            source.startswith("./")
            or source.startswith("https://github.com/")
        ):
            errors.append(
                f"Cursor plugin {name!r} source must be a relative path or GitHub URL: {source!r}"
            )
        if not CURSOR_NAME_PATTERN.fullmatch(name):
            errors.append(f"Cursor plugin name invalid: {name!r}")


def validate_name_parity(claude: dict, codex: dict, cursor: dict, errors: list[str]) -> None:
    claude_names = plugin_names(claude)
    codex_names = plugin_names(codex)
    cursor_names = plugin_names(cursor)
    if claude_names != codex_names:
        errors.append(
            f"Plugin name mismatch Claude vs Codex: {claude_names} != {codex_names}"
        )
    if claude_names != cursor_names:
        errors.append(
            f"Plugin name mismatch Claude vs Cursor: {claude_names} != {cursor_names}"
        )


def main() -> int:
    errors: list[str] = []

    for path in (CLAUDE_MANIFEST, CODEX_MANIFEST, CURSOR_MANIFEST):
        if not path.is_file():
            errors.append(f"Missing manifest: {path.relative_to(REPO_ROOT)}")
            continue
        try:
            json.load(path.open(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            errors.append(f"Invalid JSON in {path.relative_to(REPO_ROOT)}: {exc}")

    if errors:
        for error in errors:
            print(error, file=sys.stderr)
        return 1

    claude = load_json(CLAUDE_MANIFEST)
    codex = load_json(CODEX_MANIFEST)
    cursor = load_json(CURSOR_MANIFEST)

    validate_claude(claude, errors)
    validate_codex(codex, errors)
    validate_cursor(cursor, errors)
    validate_name_parity(claude, codex, cursor, errors)

    if errors:
        for error in errors:
            print(error, file=sys.stderr)
        return 1

    print(
        f"All marketplace manifests valid ({len(plugin_names(claude))} plugins in sync)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
