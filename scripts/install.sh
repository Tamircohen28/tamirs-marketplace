#!/usr/bin/env bash
# install.sh — contributor bootstrap for tamirs-plugins catalog.
#
# Usage: make install
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

missing=()
command -v python3 >/dev/null 2>&1 || missing+=("python3")
command -v git >/dev/null 2>&1 || missing+=("git")
command -v jq >/dev/null 2>&1 || missing+=("jq")

if ((${#missing[@]} > 0)); then
  echo "Missing required tools: ${missing[*]}" >&2
  echo "Install them, then re-run: make install" >&2
  exit 1
fi

if command -v gh >/dev/null 2>&1; then
  gh auth status >/dev/null 2>&1 || echo "WARN: gh not authenticated — run 'gh auth login' for PR workflows" >&2
else
  echo "WARN: gh CLI not found — optional for local validation" >&2
fi

cd "$ROOT"
make generate
echo "Contributor environment ready. Run 'make validate' before committing manifest changes."
