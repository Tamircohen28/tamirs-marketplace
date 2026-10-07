# Security — secrets & IP hygiene

See [AGENTS.md](../../AGENTS.md) for the canonical off-limits list.

- **Never commit secrets or tokens.** CI includes a secret scan that fails the
  build on common token patterns.
- **Never add employer-internal URLs, registries, credentials, or proprietary IP.**
  This is a personal, public catalog owned by `@Tamircohen28`.
- This repo is a catalog only — it never contains plugin source, so it should
  never contain build secrets or environment files.
- All three manifests (`.claude-plugin/marketplace.json`, `.agents/plugins/
  marketplace.json`, `.cursor-plugin/marketplace.json`) point at plugin repos
  with the credential-free `"source": "github", "repo": "..."` shorthand —
  never a raw clone URL with an embedded token or password. Keep it that way:
  before Claude Code 2.1.268, a plugin or marketplace error message could echo
  a token/password embedded in a git source URL back to the terminal; fixed in
  2.1.268, but a credential-free source form avoids the class of leak entirely
  regardless of Claude Code version, so don't add a plugin/marketplace entry
  as a bare URL with embedded credentials even when testing locally.
- **Never add an `archive`-source plugin entry without weighing this:** before
  Claude Code 2.1.269, a plugin archive extracted for a session could end up
  readable by other local users, keep world-writable bits, or leave stale
  files behind on re-extraction. Fixed in 2.1.269. This catalog's three
  manifests use only `github` sources today — no `archive` source anywhere —
  so no plugin installed from here was ever exposed either way, but if a
  future entry here (or a fork) does distribute a plugin as an `archive`
  source, treat the extracted directory as sensitive on any older CLI and
  prefer a Claude Code build 2.1.269 or later.
- **Watch for a stray `manifest.json` next to a skill directory.** Before Claude Code
  2.1.280, a `manifest.json` that listed a skill's name could cause Claude Code to
  wrongly move that skill in `~/.claude/skills/` into `.trash/`. Fixed in 2.1.280. This
  repo's own `.agents/skills/run-plugins-catalog/` ships only a `SKILL.md` and no
  `manifest.json`, so this catalog never triggered it — but if you're developing a
  plugin skill for `tamirs-superpowers`, `jose-claudinho`, or `headhunter` locally with
  a `manifest.json` alongside it, prefer a Claude Code build 2.1.280 or later, or drop
  the stray file.
- **Setting a bundled `.mcpb` MCP server's own secrets (e.g. `headhunter`'s Gmail/
  Calendar/Notion/Todoist integrations, if bundled that way).** Since Claude Code 2.1.285,
  prefer `claude plugin install <name>@tamirs-marketplace --config <server>.<key>=<value>`
  or `claude plugin configure <name>@tamirs-marketplace --values-stdin` over typing a
  secret value into the interactive Configure prompt or a shell command a history file
  could capture. Neither flag is specific to this catalog's own manifests — it's install-
  time guidance for anyone setting up one of the three listed plugins.
- **Mods (Claude Code 2.1.287+) run in-process and can gate a tool call or a prompt.**
  `tamirs-superpowers` ships one (`mod/register.tsx`); its own header documents it as
  additive — every bash-hook guard it overlaps with keeps running as the fallback, and
  the mod itself makes no network call. `claude plugin validate --json`'s `gatingHooks`
  report (2.1.290+) shows 4 of its hooks (`agent.spawn`, `prompt.submit`, `tool.call`,
  `session.compact`) register without a `.catch` — an unhandled exception in one of
  those hooks fails open or closed depending on the mod runtime's own default, not a
  choice this catalog's manifest controls. Worth a fix in that repo; tracked under
  Future opportunities, not actionable from this manifest-only catalog.
