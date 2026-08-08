# Troubleshooting

Per-target install guides carry their own troubleshooting tables:
[Claude Code](install/claude-code.md#troubleshooting) ·
[Cursor](install/cursor.md#troubleshooting) ·
[Codex](install/codex.md#troubleshooting) ·
[OpenCode](install/opencode.md#troubleshooting).

## Claude Code

### `/plugin marketplace add` fails

**Symptom**: `Error: could not fetch marketplace from Tamircohen28/tamirs-marketplace`

**Fixes**:
1. Confirm you are authenticated: run `/status` and check your GitHub connection
2. Confirm network access to `github.com`
3. Try again — transient GitHub API rate limits can cause this

### `Marketplace file not found`

**Symptom**: adding a source fails with a missing-manifest error

**Fix**: the source has no `.claude-plugin/marketplace.json`. For this catalog, confirm you
passed `Tamircohen28/tamirs-marketplace`. For a plugin repo installed standalone, confirm you're on a
revision new enough to ship its own marketplace manifest.

### Plugin installs but skills don't appear

**Symptom**: `/plugin install` succeeds but skills are not found

**Fix**: On Claude Code 2.1.221+ a fresh `/plugin install` activates immediately when safe, so
this mostly affects older versions: open a **new** Claude Code session — plugins load at
session start there. `/reload-plugins` reloads what's cached — it does **not** re-fetch from
GitHub. Since 2.1.221, `/plugin install` also refreshes a stale marketplace catalog and
retries before reporting a plugin not found.

### `@tamirs-marketplace` not recognized

**Symptom**: `/plugin install headhunter@tamirs-marketplace` returns `unknown marketplace`

**Fix**: Add the marketplace first:

```bash
claude plugin marketplace add Tamircohen28/tamirs-marketplace
```

### `plugin update` does nothing

**Symptom**: an update runs clean but the plugin behaves as before

**Fix**: Claude Code caches plugins by the `version` field in each plugin's `plugin.json`. A
release that didn't bump the version can't reach you. Check that plugin's releases page.

### Plugin misbehaves after being installed in several projects

**Symptom**: on Claude Code **2.1.223 or older**, installing the same plugin in multiple
projects could silently corrupt its install records, leaving the plugin in a broken state
in some of those projects.

**Fix**: upgrade to Claude Code 2.1.224+, where the corruption is fixed. If a plugin is
still misbehaving from a record corrupted on an older version, uninstall and reinstall it
(`claude plugin uninstall <name>@tamirs-plugins`, then `claude plugin install`).

---

## Codex

### Marketplace add succeeds but no plugins listed

**Symptom**: `codex plugin list --marketplace tamirs-marketplace` is empty

**Fixes**:
1. Confirm you used `--sparse .agents/plugins` when adding the marketplace
2. Upgrade the marketplace snapshot: `codex plugin marketplace upgrade tamirs-marketplace`
3. Confirm each plugin repo has `.codex-plugin/plugin.json`

### `unrecognized subcommand 'install'` / `unexpected argument '--source'`

**Fix**: the commands are `codex plugin add PLUGIN@MARKETPLACE` (or `-m MARKETPLACE`) and
`codex plugin list --marketplace MARKETPLACE`. There is no `install` subcommand and no
`--source` flag.

### `marketplace root does not contain a supported manifest`

**Fix**: Codex reads `.agents/plugins/marketplace.json`, **not**
`.codex-plugin/marketplace.json`. This catalog ships the correct path; if you hit this on a
plugin repo, it's on a revision that predates the fix.

### `remote: Repository not found` during install

**Symptom**: the plugin's git clone fails

**Fix**: the catalog entry points at a repo that is private or gone. That's a catalog bug —
[open an issue here](https://github.com/Tamircohen28/tamirs-marketplace/issues).

---

## Cursor

### Team marketplace import finds no plugins

**Symptom**: Import parses zero plugins from this repo

**Fixes**:
1. Confirm `.cursor-plugin/marketplace.json` exists on the `main` branch
2. Confirm each plugin repo has `.cursor-plugin/plugin.json`
3. Assign distribution groups — an imported marketplace with no groups reaches nobody
4. Click **Refresh** in Dashboard → Plugins after pushing catalog changes

### Local plugin does not load

**Symptom**: Symlinked plugin under `~/.cursor/plugins/local/` has no skills or rules

**Fixes**:
1. Confirm `.cursor-plugin/plugin.json` exists at the plugin root
2. Confirm the symlink points at the repo **root**, not a subdirectory
3. Run **Developer: Reload Window**
4. Check **Settings → Rules** and **Settings → MCP** for loaded components

---

## OpenCode

### This catalog can't be added

**Expected.** OpenCode has no marketplace format. Install each plugin repo directly — see
[install/opencode.md](install/opencode.md).

### Skills don't appear after cloning a plugin

**Fix**: run `opencode debug skill` to see what resolved. A relative `skills.paths` entry
resolves against the project root, so pointing at a clone outside your project needs an
**absolute** path.

### `ConfigInvalidError` at startup

**Fix**: an unknown top-level key, or `mcp[name].command` given as a string instead of an
array. `type` is also required on MCP entries (`"local"` for stdio).

### An MCP token isn't picked up

**Fix**: OpenCode interpolates `{env:VAR}`, not shell-style `${VAR}`.

---

## General

### `/doctor` or health check shows a plugin as unhealthy

**Fix**: refresh the catalog, then the plugin:

```bash
claude plugin marketplace update tamirs-marketplace
claude plugin update tamirs-superpowers@tamirs-marketplace
```

If the error persists, open an issue in the plugin's own repo (not this catalog).

### Getting more help

- Open an issue in [this repo](https://github.com/Tamircohen28/tamirs-marketplace/issues) for catalog-level problems (wrong repo URL, missing plugin entry)
- Open an issue in the plugin's own repo for plugin-level bugs
