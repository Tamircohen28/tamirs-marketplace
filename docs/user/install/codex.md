# Install — Codex

| | |
|---|---|
| **Validated against** | Codex CLI **0.146.0** |
| **Minimum supported** | **0.40.0** |
| **Marketplace manifest** | `.agents/plugins/marketplace.json` |
| **Official docs** | [Codex plugins](https://developers.openai.com/codex/plugins) |

Check your version:

```bash
codex --version
```

## The manifest path trips people up

Codex reads the marketplace from **`.agents/plugins/marketplace.json`** — *not*
`.codex-plugin/marketplace.json`. The `.codex-plugin/` directory is the **plugin**-side
manifest location; a catalog that only ships `.codex-plugin/marketplace.json` fails with:

```
Error: invalid marketplace file ...: marketplace root does not contain a supported manifest
```

This catalog ships the correct path. It is generated from the Claude manifest by
`make generate`, so it can never drift.

## Install

```bash
# 1. Add the catalog. --sparse keeps the clone to just the manifest directory.
codex plugin marketplace add Tamircohen28/plugins --ref main --sparse .agents/plugins

# 2. See what's available
codex plugin list --marketplace tamirs-plugins

# 3. Install the plugins you want
codex plugin add tamirs-superpowers@tamirs-plugins
codex plugin add jose-claudinho@tamirs-plugins
codex plugin add headhunter@tamirs-plugins

# 4. Verify
codex plugin list --marketplace tamirs-plugins
```

Step 2 prints, for the catalog as it stands today:

```
Marketplace `tamirs-plugins`
/Users/<you>/.codex/.tmp/marketplaces/tamirs-plugins/.agents/plugins/marketplace.json

PLUGIN                             STATUS         VERSION  PATH
tamirs-superpowers@tamirs-plugins  not installed           https://github.com/Tamircohen28/tamirs-superpowers.git, ref `master`
jose-claudinho@tamirs-plugins      not installed           https://github.com/Tamircohen28/jose-claudinho.git, ref `main`
headhunter@tamirs-plugins          not installed           https://github.com/Tamircohen28/headhunter.git, ref `main`
```

In the Codex app: **Settings → Plugins → + Add More…** → paste
`https://github.com/Tamircohen28/plugins`.

## Command names

`codex plugin add`, not `codex plugin install`. There is no `--source` flag — the
marketplace is selected with `@MARKETPLACE` in the selector or with `--marketplace`:

```bash
codex plugin add headhunter@tamirs-plugins        # selector form
codex plugin add headhunter -m tamirs-plugins     # flag form
```

Verified against `codex plugin add --help` on 0.146.0.

## What you get

| Plugin | What it adds |
|--------|--------------|
| `tamirs-superpowers` | 26 skills, plugin hooks, MCP server stubs |
| `jose-claudinho` | Fantasy World Cup 2026 manager |
| `headhunter` | Job-search CRM |

Each plugin's `AGENTS.md` is read natively by Codex; per-plugin skills and hooks come from
its `.codex-plugin/plugin.json`.

## Update

```bash
codex plugin marketplace upgrade tamirs-plugins
```

That refreshes the catalog snapshot. Re-run `codex plugin add <name>@tamirs-plugins` to
pull a newer plugin revision.

## Uninstall

```bash
codex plugin remove headhunter@tamirs-plugins
codex plugin marketplace remove tamirs-plugins
```

`marketplace remove` also deletes the installed marketplace root under `~/.codex/.tmp/`.

## Installing a plugin standalone instead

Every plugin in this catalog carries its own `.agents/plugins/marketplace.json`:

```bash
codex plugin marketplace add TamirCohen28/headhunter --ref main
codex plugin add headhunter@headhunter
```

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `marketplace root does not contain a supported manifest` | The source has no `.agents/plugins/marketplace.json`. For a plugin repo, check you're on a revision new enough to ship it. |
| `error: unrecognized subcommand 'install'` | Use `codex plugin add`. `install` does not exist. |
| `unexpected argument '--source'` | Use `@MARKETPLACE` in the selector, or `-m/--marketplace`. |
| `remote: Repository not found` on install | The plugin's source repo is private or gone. Report it — a catalog entry pointing at an unreachable repo is a bug in the catalog. |
| `codex plugin list` shows nothing from this catalog | You listed all marketplaces; scroll, or use `codex plugin list --marketplace tamirs-plugins`. |

More: [troubleshooting.md](../troubleshooting.md).
