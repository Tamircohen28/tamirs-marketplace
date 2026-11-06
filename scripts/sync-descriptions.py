#!/usr/bin/env python3
"""sync-descriptions.py — each catalog entry's description is its plugin repo's GitHub description.

Usage:
  python3 scripts/sync-descriptions.py            # rewrite .claude-plugin/marketplace.json in place
  python3 scripts/sync-descriptions.py --check    # exit 1 when any entry differs from its repo

Why: the catalog carried its own copy of each description, and it drifted ("26 bundled skills"
in Claude Code's /plugin view while the repo said 31). The repository's description on GitHub is
the one place it is maintained, so the catalog takes it from there; `make generate` then copies it
into the Codex and Cursor catalogs.

Reads https://api.github.com/repos/<owner>/<repo> for entries whose source is a github repo or an
https://github.com/ url. Uses GH_TOKEN / GITHUB_TOKEN when set, anonymous otherwise (three calls
fit the anonymous limit). A repository that cannot be read, or has no description, is reported
and left as it is: an unread value is never written, and --check does not fail on it.
"""
import json
import os
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MANIFEST = ROOT / ".claude-plugin" / "marketplace.json"
GITHUB_HTTPS = "https://github.com/"


def repo_of(source: dict):
    if source.get("source") == "github" and source.get("repo"):
        return source["repo"]
    url = str(source.get("url", ""))
    if source.get("source") == "url" and url.startswith(GITHUB_HTTPS):
        return url[len(GITHUB_HTTPS):].removesuffix(".git").strip("/")
    return None


def github_description(repo: str):
    req = urllib.request.Request(f"https://api.github.com/repos/{repo}",
                                 headers={"Accept": "application/vnd.github+json",
                                          "User-Agent": "tamirs-marketplace-sync-descriptions"})
    token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    try:
        with urllib.request.urlopen(req, timeout=15) as r:
            return (json.load(r).get("description") or "").strip() or None
    except Exception as e:  # network, rate limit, 404: reported, never written
        print(f"  skip {repo}: could not read its description ({e})", file=sys.stderr)
        return None


def main() -> int:
    check = "--check" in sys.argv[1:]
    data = json.loads(MANIFEST.read_text(encoding="utf-8"))
    drift = []
    for entry in data.get("plugins", []):
        repo = repo_of(entry.get("source", {}))
        if not repo:
            continue
        want = github_description(repo)
        if want is None:
            continue
        if entry.get("description") != want:
            drift.append(entry["name"])
            print(f"  {'drift' if check else 'update'} {entry['name']}: description <- {repo}")
            entry["description"] = want
    if check:
        if drift:
            print("Catalog descriptions differ from their repos: run 'make sync-descriptions'.", file=sys.stderr)
            return 1
        print("Catalog descriptions match their repos.")
        return 0
    if drift:
        MANIFEST.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"{len(drift)} description(s) updated.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
