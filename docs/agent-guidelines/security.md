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
