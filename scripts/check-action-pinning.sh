#!/usr/bin/env bash
# check-action-pinning.sh — fail when a workflow trusts a mutable action ref.
#
# WHY THIS EXISTS
#   `uses: actions/checkout@v7` does not name a version. It names a tag, and a
#   tag is a pointer the action's owner can move at any time — `v7` pointed at
#   v7.0.0 when a workflow was written and at v7.0.1 a week later, with no commit
#   in this repository and no PR to review. That is a third party's write access
#   to this repo's CI, and the whole point of `permissions:` blocks and secret
#   scanning is undone by it. A 40-character commit SHA is immutable; the
#   `# v7.0.0` comment beside it is what keeps it readable, and what Dependabot
#   rewrites when it proposes a bump.
#
#   Every action ref in this repo's `.github/workflows/` was a movable tag — five
#   `actions/checkout@v7` and one `actions/setup-node@v6` — and nothing noticed,
#   because the standard was practised rather than checked, which is the same
#   failure mode as a validator nobody runs.
#
#   This repository publishes the marketplace manifest that installs the plugin
#   into other people's editors. Its CI is worth exactly as much trust as the
#   weakest third-party tag it resolves at run time.
#
#   The first version of this script scanned `.github/workflows` and nothing else
#   — a list of places to look, written from its author's memory. In the sibling
#   repository that omission hid 18 mutable refs in a templates directory two
#   levels away, while the checker reported "all action refs are SHA-pinned". A
#   checker must not decide its verdict by where it happened to look.
#
# WHAT IS SCANNED
#   Every *.yml, *.yaml, *.tmpl and *.md in the tree (.git, node_modules and
#   .venv pruned). `.tmpl` because a scaffold template is a workflow before it is
#   rendered; `.md` because documentation carries real workflow bodies in fenced
#   blocks — and ONLY fenced blocks there, since prose about a mutable ref is not
#   a mutable ref.
#
# WHAT COUNTS AS PINNED
#   uses: owner/repo@<40 hex>              — pinned
#   uses: owner/repo@<40 hex> # v7.0.0     — pinned, and readable. Preferred.
#   uses: owner/repo@v7                    — NOT pinned: a movable tag
#   uses: owner/repo@main                  — NOT pinned: a branch
#
# WHAT IS EXEMPT, AND WHY
#   ./path            a local action in this same repository — it moves only when
#                     this repo moves, so there is nothing external to pin.
#   docker://...      reported, not failed: a digest-pinned image is the right fix
#                     but the syntax is different and none exist here today.
#   action-pin-ok:    an explicit, readable waiver — but only in the comment
#                     part of the line, after a `#`. A path-shaped carve-out is
#                     how the mutable ref creeps back; a waiver that matches
#                     anywhere on the line lets an action called
#                     `owner/action-pin-ok` waive itself.
#
# Usage: check-action-pinning.sh [<repo_root>] [--self-test]
# Exit:  0 clean · 1 mutable refs found · 2 usage/environment
set -uo pipefail

ROOT="."
SELF_TEST=0
for arg in "$@"; do
  case "$arg" in
    --self-test) SELF_TEST=1 ;;
    # Print the header block itself, not a line range. A hardcoded '2,36p'
    # silently truncates the moment the header grows -- the help text quietly
    # ceasing to describe the script is the same defect this script exists for.
    -h|--help) sed -n '2,${/^#/!q;p;}' "$0" | sed 's/^#[ ]\{0,1\}//'; exit 0 ;;
    -*) echo "check-action-pinning.sh: unknown option '$arg'" >&2; exit 2 ;;
    *) ROOT="$arg" ;;
  esac
done

# scan <dir> — every "path:line:ref" whose ref is not a 40-hex SHA.
# Prints nothing when clean. Never fails the shell; the caller decides.
scan() {
  local dir="$1" f line trimmed n ref md fence
  [ -d "$dir" ] || return 0
  while IFS= read -r f; do
    n=0; fence=0
    case "$f" in *.md) md=1 ;; *) md=0 ;; esac
    while IFS= read -r line; do
      n=$((n + 1))
      trimmed="${line#"${line%%[![:space:]]*}"}"

      # In Markdown, only fenced blocks are configuration; everything else is
      # prose ABOUT configuration. Without this, CHANGELOG.md's own entry
      # explaining that `uses: actions/checkout@v7` names a movable tag is
      # reported as a movable tag.
      if [ "$md" -eq 1 ]; then
        case "$trimmed" in '```'*|'~~~'*) fence=$((1 - fence)); continue ;; esac
        [ "$fence" -eq 1 ] || continue
      fi

      # The waiver must live in a comment, not merely somewhere on the line.
      # `*action-pin-ok:*` is the same substring match that made `causes:` parse
      # as a step: a ref whose own name carries the token -- say
      # `uses: docker://ghcr.io/owner/action-pin-ok:v1`, where the docker
      # name:tag syntax supplies the colon -- would waive itself and never be
      # reported. Only the text after the first `#` can waive.
      case "$line" in
        *'#'*) case "${line#*#}" in *action-pin-ok:*) continue ;; esac ;;
      esac

      # `uses:` must be the YAML key, not a substring. Globbing *uses:* anywhere
      # on the line makes "**Common errors and their causes:**" parse as a step
      # -- ca-uses:. Found by running this against the tree, not the fixtures.
      case "$trimmed" in '- '*) trimmed="${trimmed#- }"; trimmed="${trimmed#"${trimmed%%[![:space:]]*}"}" ;; esac
      case "$trimmed" in
        uses:*) ref="${trimmed#uses:}" ;;
        *) continue ;;
      esac
      ref="${ref%%#*}"
      ref="$(printf '%s' "$ref" | tr -d " \"'" )"
      [ -n "$ref" ] || continue
      case "$ref" in
        ./*|.\\*) continue ;;                    # local action: nothing external
        docker://*) printf '%s:%s:%s (docker ref — pin by digest)\n' "$f" "$n" "$ref"; continue ;;
      esac
      case "$ref" in
        *@*) : ;;
        *) printf '%s:%s:%s (no ref at all)\n' "$f" "$n" "$ref"; continue ;;
      esac
      case "${ref##*@}" in
        [0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]) : ;;
        *) printf '%s:%s:%s\n' "$f" "$n" "$ref" ;;
      esac
    done < "$f"
  done < <(find "$dir" \( -name .git -o -name node_modules -o -name .venv \) -prune -o \
           \( -name '*.yml' -o -name '*.yaml' -o -name '*.tmpl' -o -name '*.md' \) \
           -type f -print 2>/dev/null | sort)
}

# --- positive control ------------------------------------------------------
# A checker that has never been shown to fail is indistinguishable from one that
# cannot. This builds both a violating workflow and its corrected twin.
self_test() {
  local tmp rc=0 out
  tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' RETURN
  mkdir -p "$tmp/bad" "$tmp/good"

  cat > "$tmp/bad/w.yml" <<'YML'
jobs:
  a:
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-node@main
      - uses: ./.github/actions/local
      - uses: some/act@1111111111111111111111111111111111111111 # v1.2.3
      - uses: waived/act@v2 # action-pin-ok: vendor publishes no SHA
      - uses: docker://ghcr.io/owner/action-pin-ok:v1
YML
  out="$(scan "$tmp/bad")"
  [ "$(printf '%s\n' "$out" | grep -c 'checkout@v7')" = 1 ] \
    || { echo "  self-test: movable tag not caught" >&2; rc=1; }
  [ "$(printf '%s\n' "$out" | grep -c 'setup-node@main')" = 1 ] \
    || { echo "  self-test: branch ref not caught" >&2; rc=1; }
  [ "$(printf '%s\n' "$out" | grep -c 'actions/local')" = 0 ] \
    || { echo "  self-test: local action wrongly flagged" >&2; rc=1; }
  [ "$(printf '%s\n' "$out" | grep -c 'some/act')" = 0 ] \
    || { echo "  self-test: SHA-pinned ref wrongly flagged" >&2; rc=1; }
  [ "$(printf '%s\n' "$out" | grep -c 'waived/act')" = 0 ] \
    || { echo "  self-test: action-pin-ok waiver ignored" >&2; rc=1; }
  # The waiver token inside the REF, with the colon supplied by docker's name:tag
  # syntax. A fixture like `owner/action-pin-ok@v4` cannot test this: no colon
  # follows the token, so the buggy substring waiver never fired on it either and
  # the assertion would pass with fix 4 reverted.
  [ "$(printf '%s\n' "$out" | grep -c 'owner/action-pin-ok')" = 1 ] \
    || { echo "  self-test: waiver token in the ref itself waived the line" >&2; rc=1; }

  # --- cases the fixtures did not have, and the real tree did -----------------
  # Each of these three was a live false positive or blind spot, found by running
  # the detector against a real repository rather than against what its author
  # imagined.
  cat > "$tmp/bad/prose.md" <<'MD'
- `uses: actions/checkout@v7` names a tag, not a version. Do not copy this line.
A doc may also show the bare key in prose, like so:

uses: prose/unfenced@v2

```yaml
      - uses: prose/fenced@v9
```
MD
  cat > "$tmp/bad/sub.yml" <<'YML'
# comment mentioning uses: commented/out@v3 which is not a step
steps:
  - name: notes
    run: echo "**Common errors and their causes:**"
YML
  cat > "$tmp/bad/t.yml.tmpl" <<'TMPL'
jobs:
  a:
    steps:
      - uses: tmpl/act@v1
TMPL
  out="$(scan "$tmp/bad")"
  [ "$(printf '%s\n' "$out" | grep -c 'checkout@v7')" = 1 ] \
    || { echo "  self-test: markdown PROSE wrongly flagged (or bad/w.yml missed)" >&2; rc=1; }
  [ "$(printf '%s\n' "$out" | grep -c 'prose/fenced')" = 1 ] \
    || { echo "  self-test: fenced markdown block not scanned" >&2; rc=1; }
  [ "$(printf '%s\n' "$out" | grep -c 'prose/unfenced')" = 0 ] \
    || { echo "  self-test: unfenced markdown prose read as a step" >&2; rc=1; }
  # sub.yml contains NO step at all: a YAML comment naming a ref, and a run: line
  # ending in "causes:". Any finding from it is a false positive, whatever it says
  # -- assert on the file, not on the text, because the report prints the extracted
  # ref and never the source line.
  [ "$(printf '%s\n' "$out" | grep -c 'sub.yml')" = 0 ] \
    || { echo "  self-test: false positive in a file with no steps" >&2; rc=1; }
  [ "$(printf '%s\n' "$out" | grep -c 'tmpl/act')" = 1 ] \
    || { echo "  self-test: .tmpl scaffold template not scanned" >&2; rc=1; }

  cat > "$tmp/good/w.yml" <<'YML'
jobs:
  a:
    steps:
      - uses: actions/checkout@9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0 # v7.0.0
YML
  [ -z "$(scan "$tmp/good")" ] \
    || { echo "  self-test: corrected workflow still flagged" >&2; rc=1; }

  [ "$rc" -eq 0 ] && echo "  self-test passed (detector fires, and goes quiet when fixed)"
  return "$rc"
}

if [ "$SELF_TEST" -eq 1 ]; then
  self_test || exit 1
fi

cd "$ROOT" 2>/dev/null || { echo "check-action-pinning.sh: no such directory: $ROOT" >&2; exit 2; }

# The whole repository, not a list of places to look. Naming ".github/workflows"
# made the verdict depend on the completeness of its author's memory: a workflow
# fragment in a doc, a template, or a directory added next month is invisible,
# and the script still prints "all action refs are SHA-pinned". Scan everything;
# waive by comment, never by path.
findings="$(scan ".")"

if [ -n "$findings" ]; then
  echo "  mutable action refs — pin to a 40-char commit SHA with a '# <version>' comment:" >&2
  printf '%s\n' "$findings" | sed 's/^/    /' >&2
  echo "  resolve with: gh api repos/<owner>/<repo>/git/ref/tags/<tag> --jq .object.sha" >&2
  exit 1
fi

echo "  all action refs are SHA-pinned"
