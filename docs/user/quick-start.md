# Quick Start

Get plugins installed in under 5 minutes. Pick your platform below.

## Claude Code

### Prerequisites

- Claude Code installed and authenticated
- `claude` CLI accessible in your terminal

### Install

```bash
# 1. Add the marketplace
claude plugin marketplace add Tamircohen28/plugins

# 2. Install plugins
claude plugin install tamirs-superpowers@tamirs-plugins
claude plugin install jose-claudinho@tamirs-plugins
claude plugin install headhunter@tamirs-plugins

# 3. Verify
claude plugin list
```

Inside Claude Code, use slash commands instead:

```text
/plugin marketplace add Tamircohen28/plugins
/plugin install tamirs-superpowers@tamirs-plugins
/doctor
```

Tips (Claude Code 2.1.163+):

- Browsing the marketplace in `/plugin`? There's a search bar — start typing a
  plugin name instead of scrolling.
- `claude plugin list --enabled` (or `--disabled`) filters the verify step to
  what's actually active.
- The `/plugin` Installed tab has a **Skills** section showing every skill each
  installed plugin contributes.

Open a **new** session after installing to load skills.

---

## Codex

### Prerequisites

- Codex app or CLI installed and signed in

### Install

```bash
# 1. Add the marketplace
codex plugin marketplace add Tamircohen28/plugins --ref main --sparse .agents/plugins

# 2. Install plugins
codex plugin install tamirs-superpowers --source plugins
codex plugin install jose-claudinho --source plugins
codex plugin install headhunter --source plugins

# 3. Verify
codex plugin list
```

In the Codex app: **Settings → Plugins → + Add More…** → paste `https://github.com/Tamircohen28/plugins`.

---

## Cursor

### Team marketplace (Teams / Enterprise)

1. Admin: **Dashboard → Settings → Plugins → Import Marketplace**
2. Repository: `https://github.com/Tamircohen28/plugins`
3. Developer: open the marketplace panel in Cursor and install plugins

### Local development (any plan)

```bash
git clone https://github.com/Tamircohen28/tamirs-superpowers
ln -s "$(pwd)/tamirs-superpowers" ~/.cursor/plugins/local/tamirs-superpowers
```

Restart Cursor or run **Developer: Reload Window**.

---

## Updating plugins

Plugins are fetched from their pinned branch on install. To refresh:

```bash
# Claude Code
claude plugin update tamirs-superpowers

# Codex
codex plugin marketplace upgrade plugins
```

See [Troubleshooting](troubleshooting.md) if a plugin installs but skills do not appear.
