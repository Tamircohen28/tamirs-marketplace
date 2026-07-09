#!/usr/bin/env bash
# update.sh — refresh local catalog checkout and regenerate manifests.
#
# Usage: make update
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DEFAULT=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||' || echo main)
git fetch --prune origin
git pull --rebase "origin/$DEFAULT"
make generate
echo "Catalog updated and manifests regenerated."
