#!/usr/bin/env python3
"""Generate Codex and Cursor marketplace manifests from the canonical Claude manifest."""

from __future__ import annotations

import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
CLAUDE_MANIFEST = REPO_ROOT / ".claude-plugin" / "marketplace.json"
CODEX_MANIFEST = REPO_ROOT / ".agents" / "plugins" / "marketplace.json"
CURSOR_MANIFEST = REPO_ROOT / ".cursor-plugin" / "marketplace.json"

DEFAULT_CODEX_CATEGORY = "Developer Tools"

# Optional per-plugin Codex category overrides.
CODEX_CATEGORY_OVERRIDES: dict[str, str] = {
    "jose-claudinho": "Productivity",
    "headhunter": "Productivity",
}


def load_claude_manifest() -> dict:
    with CLAUDE_MANIFEST.open(encoding="utf-8") as f:
        return json.load(f)


def github_repo_to_url(repo: str, with_git_suffix: bool = True) -> str:
    url = f"https://github.com/{repo}"
    if with_git_suffix:
        return f"{url}.git"
    return url


GITHUB_HTTPS = "https://github.com/"


def parse_github_source(source: dict) -> tuple[str, str | None]:
    """owner/repo and ref from a Claude source on GitHub.

    Two spellings mean the same repository: {"source": "github", "repo": "o/r"} and
    {"source": "url", "url": "https://github.com/o/r.git"}. The catalog uses the url form
    because Claude Code clones a github source over SSH, which fails for anyone without a
    GitHub SSH key ("Permission denied (publickey)", 2026-11-06); an https url clones
    anonymously for a public repository.
    """
    kind = source.get("source")
    if kind == "github":
        repo = source.get("repo")
    elif kind == "url" and str(source.get("url", "")).startswith(GITHUB_HTTPS):
        repo = source["url"][len(GITHUB_HTTPS):].removesuffix(".git").strip("/")
    else:
        raise ValueError(
            f"Unsupported Claude source {source!r}; "
            "only github sources and https://github.com/ url sources are supported"
        )
    if not repo or "/" not in repo:
        raise ValueError(f"Invalid github repo: {repo!r}")
    ref = source.get("ref")
    return repo, ref


def build_codex_manifest(claude: dict) -> dict:
    plugins = []
    for entry in claude["plugins"]:
        repo, ref = parse_github_source(entry["source"])
        plugin: dict = {
            "name": entry["name"],
            "source": {
                "source": "url",
                "url": github_repo_to_url(repo, with_git_suffix=True),
            },
            "policy": {
                "installation": "AVAILABLE",
                "authentication": "ON_INSTALL",
            },
            "category": CODEX_CATEGORY_OVERRIDES.get(
                entry["name"], DEFAULT_CODEX_CATEGORY
            ),
            "description": entry["description"],
        }
        if ref:
            plugin["source"]["ref"] = ref
        plugins.append(plugin)

    display_name = claude.get("description") or claude["name"]
    return {
        "name": claude["name"],
        "interface": {"displayName": display_name},
        "plugins": plugins,
    }


def build_cursor_manifest(claude: dict) -> dict:
    owner = claude.get("owner", {})
    cursor_owner: dict = {"name": owner.get("name", "Unknown")}
    if owner.get("email"):
        cursor_owner["email"] = owner["email"]

    # Cursor schema allows relative paths or remote GitHub URLs. This catalog
    # repo is pointers-only (no vendored plugin folders), so entries use URLs.
    plugins = []
    for entry in claude["plugins"]:
        repo, _ref = parse_github_source(entry["source"])
        plugins.append(
            {
                "name": entry["name"],
                "source": github_repo_to_url(repo, with_git_suffix=False),
                "description": entry["description"],
            }
        )

    manifest: dict = {
        "name": claude["name"],
        "owner": cursor_owner,
        "metadata": {
            "description": claude.get("description", ""),
        },
        "plugins": plugins,
    }
    if claude.get("version"):
        manifest["metadata"]["version"] = claude["version"]
    return manifest


def write_json(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def main() -> int:
    try:
        claude = load_claude_manifest()
        codex = build_codex_manifest(claude)
        cursor = build_cursor_manifest(claude)
    except (OSError, json.JSONDecodeError, ValueError, KeyError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    write_json(CODEX_MANIFEST, codex)
    write_json(CURSOR_MANIFEST, cursor)
    print(f"Wrote {CODEX_MANIFEST.relative_to(REPO_ROOT)}")
    print(f"Wrote {CURSOR_MANIFEST.relative_to(REPO_ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
