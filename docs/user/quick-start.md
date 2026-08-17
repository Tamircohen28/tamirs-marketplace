# Quick Start

Get plugins installed in under 5 minutes. Pick your platform below.

| Target | Minimum | Validated against | Detailed guide |
|--------|---------|-------------------|----------------|
| Claude Code | 2.0.0 | 2.1.226 | [install/claude-code.md](install/claude-code.md) |
| Cursor | 3.16.17 | 3.16.17 | [install/cursor.md](install/cursor.md) |
| Codex | 0.40.0 | 0.146.0 | [install/codex.md](install/codex.md) |
| OpenCode | 1.16.2 | 1.18.11 | [install/opencode.md](install/opencode.md) |

## Claude Code

### Prerequisites

- Claude Code ≥ 2.0.0, installed and authenticated (`claude --version`)
- `claude` CLI accessible in your terminal

### Install

```bash
# 1. Add the marketplace
claude plugin marketplace add Tamircohen28/tamirs-marketplace

# 2. Install plugins
claude plugin install tamirs-superpowers@tamirs-marketplace
claude plugin install jose-claudinho@tamirs-marketplace
claude plugin install headhunter@tamirs-marketplace

# 3. Verify
claude plugin list
```

Inside Claude Code, use slash commands instead:

```text
/plugin marketplace add Tamircohen28/tamirs-marketplace
/plugin install tamirs-superpowers@tamirs-marketplace
/doctor
```

Tips (Claude Code 2.1.163+):

- Browsing the marketplace in `/plugin`? There's a search bar — start typing a
  plugin name instead of scrolling.
- `claude plugin list --enabled` (or `--disabled`) filters the verify step to
  what's actually active.
- The `/plugin` Installed tab has a **Skills** section showing every skill each
  installed plugin contributes.

On Claude Code 2.1.221+, plugins installed with `/plugin install` activate immediately
when safe. On older versions, open a **new** session after installing to load skills.

---

## Codex

### Prerequisites

- Codex CLI ≥ 0.40.0 or the Codex app, signed in (`codex --version`)

### Install

```bash
# 1. Add the marketplace (--sparse keeps the clone small)
codex plugin marketplace add Tamircohen28/tamirs-marketplace --ref main --sparse .agents/plugins

# 2. See what's available
codex plugin list --marketplace tamirs-marketplace

# 3. Install plugins
codex plugin add tamirs-superpowers@tamirs-marketplace
codex plugin add jose-claudinho@tamirs-marketplace
codex plugin add headhunter@tamirs-marketplace

# 4. Verify
codex plugin list --marketplace tamirs-marketplace
```

The subcommand is `codex plugin add` — there is no `codex plugin install` and no
`--source` flag. Select the marketplace with `@tamirs-marketplace` or `-m tamirs-marketplace`.

In the Codex app: **Settings → Plugins → + Add More…** → paste `https://github.com/Tamircohen28/tamirs-marketplace`.

---

## Cursor

### Prerequisites

- Cursor ≥ 3.16.17 (**Cursor → About Cursor**). Cursor documents no minimum for plugins;
  3.16.17 is what this catalog was validated on.

### Team marketplace (Teams / Enterprise)

1. Admin: **Dashboard → Plugins → Team Marketplaces → Add Marketplace → Import from Repo**
2. Repository: `https://github.com/Tamircohen28/tamirs-marketplace`
3. Save, then assign distribution groups
4. Developer: open the marketplace panel in Cursor and install plugins

### Local development (any plan)

```bash
git clone https://github.com/Tamircohen28/tamirs-superpowers
ln -s "$(pwd)/tamirs-superpowers" ~/.cursor/plugins/local/tamirs-superpowers
```

Restart Cursor or run **Developer: Reload Window**.

---

## OpenCode

### Prerequisites

- OpenCode ≥ 1.16.2 (`opencode --version`)

**OpenCode has no marketplace**, so this catalog cannot be added as an install source. Clone
the plugin repo you want — OpenCode discovers its skills natively:

```bash
git clone https://github.com/Tamircohen28/tamirs-superpowers
cd tamirs-superpowers
opencode
```

Verify with `opencode debug skill`. To use a plugin's skills from *your* project, point
`skills.paths` in your `opencode.json` at an **absolute** path to the clone's `skills/`
directory.

Full detail — config strictness, capability gaps, troubleshooting:
[install/opencode.md](install/opencode.md).

---

## Updating plugins

Plugins are fetched from their pinned branch on install. To refresh:

```bash
# Claude Code — refresh the catalog, then the plugin
claude plugin marketplace update tamirs-marketplace
claude plugin update tamirs-superpowers@tamirs-marketplace

# Codex — refresh the catalog snapshot
codex plugin marketplace upgrade tamirs-marketplace

# Cursor — team marketplace installs refresh automatically on push
# OpenCode — git pull in the clone, then restart
```

> Claude Code caches plugins by the `version` in each plugin's `plugin.json`. If a plugin
> release didn't bump its version, `plugin update` is a no-op.

See [Troubleshooting](troubleshooting.md) if a plugin installs but skills do not appear.
