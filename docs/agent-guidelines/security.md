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
