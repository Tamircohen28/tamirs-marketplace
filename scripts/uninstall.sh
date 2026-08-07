#!/usr/bin/env bash
# uninstall.sh — no local install artifacts for the catalog repo.
#
# Usage: make uninstall
set -euo pipefail

echo "tamirs-marketplace is a catalog-only repo — nothing to uninstall locally."
echo "To remove installed plugins, use your host's plugin commands:"
echo "  Claude Code: claude plugin uninstall <name>@tamirs-marketplace"
echo "  Codex:       codex plugin uninstall <name>"
echo "  Cursor:      remove via Settings → Plugins"
