# Versioning and release

This catalog follows [Semantic Versioning](https://semver.org/). The canonical
version lives in `.claude-plugin/marketplace.json` (`version` field). Codex and
Cursor manifests are generated from that file — never bump them by hand.

## Bump rules

| Bump | When |
|------|------|
| PATCH | Manifest description tweaks, doc-only, validation script fixes |
| MINOR | New plugin entry, new multi-agent targets, backward-compatible CI |
| MAJOR | Removed plugin, breaking manifest schema, renamed marketplace |

## Release checklist

1. Move `[Unreleased]` entries in `CHANGELOG.md` and `docs/CHANGELOG.md`.
2. Bump `.claude-plugin/marketplace.json` `version`.
3. Run `make generate` and `make validate`.
4. Merge to `main`, then run the [Release workflow](https://github.com/Tamircohen28/plugins/actions/workflows/release.yml) or tag manually:

```bash
VER=$(jq -r .version .claude-plugin/marketplace.json)
git tag -a "v${VER}" -m "v${VER}"
git push origin "v${VER}"
```

## Validate

```bash
VER=$(jq -r .version .claude-plugin/marketplace.json)
git tag -l "v${VER}" | grep -q . || echo "missing tag v${VER}"
make validate
```
