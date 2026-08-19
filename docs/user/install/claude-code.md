# Install — Claude Code

| | |
|---|---|
| **Validated against** | Claude Code **2.1.235** |
| **Minimum supported** | **2.0.0** |
| **Marketplace manifest** | `.claude-plugin/marketplace.json` (canonical) |
| **Official docs** | [Marketplaces](https://code.claude.com/docs/en/plugin-marketplaces) · [Plugins reference](https://code.claude.com/docs/en/plugins-reference) |

Check your version:

```bash
claude --version
```

## Prerequisites

- Claude Code 2.0.0 or newer — 2.1.235 is what this release was validated on
- Nothing else. Installing plugins needs no Python and no clone; Python 3 is a
  **contributor**-only dependency for `make generate`.

## Install

```bash
# 1. Add the catalog
claude plugin marketplace add Tamircohen28/tamirs-marketplace

# 2. Install the plugins you want
claude plugin install tamirs-superpowers@tamirs-marketplace
claude plugin install jose-claudinho@tamirs-marketplace
claude plugin install headhunter@tamirs-marketplace

# 3. Verify
claude plugin list
```

Inside an interactive session, the slash-command equivalent:

```text
/plugin marketplace add Tamircohen28/tamirs-marketplace
/plugin install tamirs-superpowers@tamirs-marketplace
/doctor
```

Since Claude Code 2.1.221, plugins installed with `/plugin install` activate immediately
when safe — no new session needed. On older versions (or when instant activation isn't
safe), open a **new** session after installing — skills load at session start.

## What you get

| Plugin | What it adds |
|--------|--------------|
| `tamirs-superpowers` | 26 skills, worktree hooks, statusline, MCP server stubs |
| `jose-claudinho` | Fantasy World Cup 2026 manager — market/team/league MCP tools |
| `headhunter` | Job-search CRM — pipeline, interviews, Gmail/Calendar/Notion/Todoist |

Each plugin's own repo documents its skills, commands, and integrations in detail.

## Useful flags (2.1.163+)

- `/plugin` has a **search bar** when browsing the marketplace — type instead of scrolling.
- `claude plugin list --enabled` / `--disabled` filters the verify step to what's active.
- The `/plugin` Installed tab has a **Skills** section listing every skill each plugin
  contributes.
- `claude plugin details <name>` prints a component inventory and projected token cost.

## Update

```bash
claude plugin marketplace update tamirs-marketplace
claude plugin update tamirs-superpowers@tamirs-marketplace
```

> **Claude Code caches installed plugins by the `version` field in the plugin's
> `plugin.json`.** If a plugin release did not bump its version, `plugin update` is a no-op
> — you stay on the cached copy. `/reload-plugins` does **not** re-fetch from GitHub; it
> only reloads what is already cached.

Updating the *catalog* (`marketplace update`) refreshes the plugin list — which plugins
exist and where they point. Updating a *plugin* fetches its source.

## Installing a plugin standalone instead

Every plugin in this catalog also carries its own `.claude-plugin/marketplace.json`, so you
can skip the catalog entirely:

```text
/plugin marketplace add TamirCohen28/headhunter
/plugin install headhunter@headhunter
```

## Plugin sources: git, archive, and command (2.1.224+ / 2.1.229+)

Every entry in this catalog is a `github` source pinned to a branch — installing fetches
the plugin's repo over git, and `plugin update` tracks that branch. Since Claude Code
2.1.224, marketplaces can alternatively distribute a plugin as an **`archive` source**: a
zip downloaded over HTTPS, with no git or npm required and optional SHA-256 pinning for
integrity. Since 2.1.229 there is also a **`command` source**: a local command prints the
plugin directory, the result is re-resolved at every session start and applied without a
restart, and `mode: "link"` uses the printed directory in place — built for cases where
another tool (an IDE, a monorepo script, a dev clone) owns the plugin's location. This
catalog itself offers neither — its entries stay `github` sources, and nothing changes
for installs from here — but plugin *developers* working on any plugin in this family
should prefer a local command-source entry with `mode: "link"` over hand-editing the
plugin cache; each plugin repo's development docs cover the pattern.

Since Claude Code 2.1.232, marketplaces themselves can also live on **GitLab**: a bare
`gitlab.com` repo URL (including nested subgroups) passed to `/plugin marketplace add`
clones just like a `github.com` URL, and clone auth-failure hints now name your actual
git host. This catalog stays on GitHub — nothing changes for installs from here — but
if you mirror or fork this catalog into a GitLab group, the mirror is now addable
directly by its repo URL. Since 2.1.233, GitLab merge-request URLs are also accepted by
`--worktree` and shown in the `claude agents` view (as `!N`) — orthogonal to marketplace
installs, but relevant if you work against a GitLab mirror of a plugin repo. Since 2.1.234,
an open GitLab MR for the current branch also shows as a badge in the footer/statusline,
extending the same MR-awareness to the session UI.

## Uninstall

```bash
claude plugin uninstall headhunter@tamirs-marketplace
claude plugin marketplace remove tamirs-marketplace
```

## Managed (enterprise) environments

Since Claude Code 2.1.223, the `strictKnownMarketplaces` and `blockedMarketplaces`
managed settings accept **owner wildcards**. An admin who wants to allow this catalog
*and* every standalone plugin repo it points at can allowlist the owner once instead
of enumerating repos:

```json
{ "strictKnownMarketplaces": ["Tamircohen28/*"] }
```

That covers `Tamircohen28/plugins` (this catalog) plus the standalone marketplaces the
plugins ship themselves (e.g. `Tamircohen28/tamirs-superpowers`, `TamirCohen28/headhunter`).
On versions older than 2.1.223, list each repo explicitly. The same wildcard form works
in `blockedMarketplaces`.

Since Claude Code 2.1.232, settings files also accept **`allowedMarketplaces`** as a
friendlier alias for `strictKnownMarketplaces`, and **`additionalMarketplaces`** as an
alias for `extraKnownMarketplaces` — the example above can be written
`{ "allowedMarketplaces": ["Tamircohen28/*"] }` on 2.1.232+. The original names keep
working, so settings that must run on older versions should stay on them. Also since
2.1.232, a url-typed `blockedMarketplaces` entry for a bare repo URL keeps blocking
that URL even when the CLI classifies it as a git clone — closing a gap where a
blocked marketplace could slip through under a different source classification.

Since Claude Code 2.1.228, marketplace entries defined in **settings files merge as
whole entries** across settings tiers. Before that, a marketplace redefined in a
higher-precedence tier (say, a user settings file overriding a managed one) could
silently inherit another tier's custom headers — for a catalog fetched over plain
git like this one that was mostly invisible, but if you pin marketplaces with custom
HTTP headers in one tier and redefine the same entry in another, 2.1.228 is where
the two stop bleeding into each other.

## Claude Code 2.1.235

Reviewed for catalog impact: the new opt-in `spellcheck` setting (underlines misspelled
words in the editor using `aspell`/`hunspell`/`ispell`), improved permission dialogs and
context-limit error messages, Vim mode preserving NORMAL mode and cursor position when
toggling the transcript, and `claude rc` applying enterprise-gateway availability checks
for Remote Control are all editor/host-side and touch nothing this catalog's
`.claude-plugin/marketplace.json` or manifests rely on — no marketplace or plugin-source
behavior changed. Nothing here is adopted as a catalog capability.

## Claude Code 2.1.234

Reviewed for catalog impact: `CLAUDE_CODE_PROJECT_DIR_NAME`, auto-continue on usage-limit
reset, account-email-only identification, Windows NT-namespace path-read hardening, Remote
Control cross-session/org-switch sync, `/permissions` and `/add-dir` usable mid-turn, `/goal`
improvements, and the removed "Default teammate model" setting are all host/session-side and
touch nothing this catalog's `.claude-plugin/marketplace.json` or manifests rely on. The one
catalog-adjacent item — the GitLab MR footer/statusline badge — is documented above.

## Skill frontmatter validation (2.1.233+)

Since Claude Code 2.1.233, `claude plugin validate` also checks **bare `.claude/skills`
directories**, reporting any `SKILL.md` whose frontmatter fails to parse. This catalog's
own contributor skill lives at `.agents/skills/run-plugins-catalog` — not a bare
`.claude/skills` directory, so the new check doesn't change how it's discovered — and CI
now runs `claude plugin validate --strict .agents/skills` on every push regardless, to
catch a frontmatter regression there before it reaches a session. If you fork this catalog and add a skill
under a bare `.claude/skills` directory of your own, the same 2.1.233 check applies to it
automatically — no extra setup needed.

Also fixed in 2.1.233: bundled skills like `/checkup` and `/review` no longer report
"Unknown command" in `-p` mode or with plugins/MCP loaded when a user or project skill of
the same name shadows them. None of this catalog's own plugins currently ship a skill
named `checkup` or `review`, so this fix is compatibility-relevant but not a functional
change here.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `Marketplace file not found` | The source has no `.claude-plugin/marketplace.json`. Check you passed `Tamircohen28/tamirs-marketplace` and not a plugin repo on an old revision. |
| Plugin installs but skills don't appear | On 2.1.221+ installs activate immediately when safe; otherwise start a **new** session. Skills load at session start, not on install. |
| `plugin update` does nothing | The plugin release didn't bump its `version`. Check that plugin's releases page. |
| A plugin name isn't found | Since 2.1.232 `/plugin install <name>@tamirs-marketplace` refreshes the catalog **first**, so a just-published plugin installs with no manual step. 2.1.221–2.1.231 refresh a stale catalog and retry on failure; on older versions run `claude plugin marketplace update tamirs-marketplace` first. |
| The marketplace vanished from `/plugin` | Before 2.1.232, a startup race between concurrent writes to `known_marketplaces.json` could silently unregister a marketplace. Fixed in 2.1.232 — on older versions, re-add with `claude plugin marketplace add Tamircohen28/tamirs-marketplace`. |
| A skill's `SKILL.md` frontmatter silently does nothing | Since 2.1.233, `claude plugin validate --strict <path>` reports the parse error directly instead of the skill just not loading. This catalog runs it in CI on `.agents/skills`. |
| `/doctor` reports a stale plugin | `claude plugin marketplace update tamirs-marketplace`, then `claude plugin update <name>@tamirs-marketplace`. |

More: [troubleshooting.md](../troubleshooting.md).
