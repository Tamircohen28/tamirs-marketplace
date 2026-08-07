@AGENTS.md

# CLAUDE.md — tamirs-marketplace

Project policy, commands, key files, and off-limits live in **[AGENTS.md](AGENTS.md)**
(imported above) — that file is canonical for every agent. Do not duplicate its
content here.

## Claude Code notes

- When editing manifests, always run `make validate` before committing — CI will
  reject out-of-sync generated files.
- Prefer the `/doctor` check after marketplace changes to confirm the catalog is
  installable.
