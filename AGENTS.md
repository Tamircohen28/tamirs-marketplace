# AGENTS.md — tamirs-plugins

Canonical agent guidance for this repository. Claude Code (`CLAUDE.md`), Cursor
(`.cursor/rules/`), and Codex all point here — this file is the single source of
truth. Keep it plain Markdown and under 32 KiB.

## What this repo is

A **multi-platform plugin catalog** — it holds marketplace manifests that point
to each plugin's own repository. **No plugin source lives here.** The Claude
manifest is canonical; the Codex and Cursor manifests are generated from it.

## Commands

| Command | What it does |
|---------|--------------|
| `make generate` | Regenerate Codex + Cursor manifests from the Claude manifest |
| `make validate` | Run `generate`, validate all manifests, and fail if generated files are out of sync |

Python 3 is required for the generator/validator. There is no build or runtime
step — installing plugins needs only a supported host (Claude Code, Cursor, or
Codex CLI).

## Working agreements

- **Edit the Claude manifest only.** `.claude-plugin/marketplace.json` is the
  source; `.agents/plugins/marketplace.json` and `.cursor-plugin/marketplace.json`
  are **generated** — never hand-edit them.
- After any manifest change, run `make generate` then `make validate` and commit
  the regenerated files. CI rejects out-of-sync manifests.
- Adding a plugin: add an entry to the `plugins` array in the Claude manifest,
  run `make generate`, add a row to the README table, add a `CHANGELOG.md` entry
  under `[Unreleased]`, then `make validate`.
- Commit convention: `<type>: <description>` with a trailing
  `Co-Authored-By: Claude <noreply@anthropic.com>`. Types: `feat` (new plugin),
  `fix`, `chore` (description update), `docs`.

## Key files

| Path | Purpose |
|------|---------|
| `.claude-plugin/marketplace.json` | Canonical Claude Code marketplace manifest (edit this) |
| `.agents/plugins/marketplace.json` | Codex marketplace manifest (generated) |
| `.cursor-plugin/marketplace.json` | Cursor team marketplace manifest (generated) |
| `scripts/generate-marketplaces.py` | Generator: Claude → Codex + Cursor |
| `scripts/validate-marketplaces.py` | Cross-platform manifest validation |
| `README.md` | User-facing install instructions |
| `CHANGELOG.md` | Version history |

## Detailed guidelines

- [docs/agent-guidelines/style.md](docs/agent-guidelines/style.md) — manifest and doc conventions
- [docs/agent-guidelines/testing.md](docs/agent-guidelines/testing.md) — how to validate changes
- [docs/agent-guidelines/security.md](docs/agent-guidelines/security.md) — secrets and IP hygiene

## Off-limits

- **Never add plugin source code here** — plugins live in their own repos.
- **Never hand-edit generated manifests** (`.agents/plugins/`, `.cursor-plugin/`) — regenerate instead.
- **Never change `"source": "github"`** in the Claude manifest — it's the only supported source type.
- **Never add Wix-internal URLs, registries, or credentials.** This is a personal, public catalog.
- **Never commit secrets or tokens.**
