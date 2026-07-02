# Security — secrets & IP hygiene

See [AGENTS.md](../../AGENTS.md) for the canonical off-limits list.

- **Never commit secrets or tokens.** CI includes a secret scan that fails the
  build on common token patterns.
- **Never add Wix-internal URLs, registries, credentials, or proprietary IP.**
  This is a personal, public catalog owned by `@Tamircohen28`.
- This repo is a catalog only — it never contains plugin source, so it should
  never contain build secrets or environment files.
