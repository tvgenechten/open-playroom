#!/usr/bin/env bash
#
# Builds the changelog section for a release from the conventional-commit subjects
# since the previous v* tag, prepends it to CHANGELOG.md and writes the same section
# to stdout so a workflow can reuse it as a pull request or release body.
#
#   release-changelog.sh <version> [<changelog-file>]
#
# With no previous tag it covers the whole history, which is what the first release
# needs. Merge commits are skipped: their subjects describe the merge, not the change.
set -euo pipefail

die() { printf 'release-changelog: %s\n' "$*" >&2; exit 1; }

[[ $# -ge 1 ]] || die "usage: release-changelog.sh <version> [<changelog-file>]"
VERSION="$1"
CHANGELOG="${2:-CHANGELOG.md}"

previous_tag="$(git tag --list 'v*' --sort=-v:refname | head -1)"
if [[ -n "$previous_tag" ]]; then
    range="$previous_tag..HEAD"
    compared_to="$previous_tag"
else
    range="HEAD"
    compared_to="the beginning"
fi

# %H lets the body be looked up per commit for BREAKING CHANGE; %s is the subject.
mapfile_compat() { while IFS= read -r line; do printf '%s\n' "$line"; done; }
commits="$(git log --no-merges --reverse --format='%H%x1f%s' "$range" | mapfile_compat)"

breaking=() features=() fixes=() refactors=() other=()
conventional='^([a-z]+)(\(([^)]+)\))?(!)?:[[:space:]]*(.+)$'

while IFS=$'\x1f' read -r sha subject; do
    [[ -n "${sha:-}" ]] || continue
    short="${sha:0:7}"

    # type(scope)!: description -- the pattern lives in a variable because bash reads
    # the ")?(" in it as extglob when it is written inline.
    if [[ "$subject" =~ $conventional ]]; then
        type="${BASH_REMATCH[1]}"
        scope="${BASH_REMATCH[3]}"
        bang="${BASH_REMATCH[4]}"
        text="${BASH_REMATCH[5]}"
    else
        # Not a conventional commit; keep it rather than hide it.
        type="other"; scope=""; bang=""; text="$subject"
    fi

    entry="- ${scope:+**$scope:** }$text (\`$short\`)"

    if [[ -n "$bang" ]] || git log -1 --format='%B' "$sha" | grep -q '^BREAKING CHANGE'; then
        breaking+=("$entry")
        continue
    fi

    case "$type" in
        feat)     features+=("$entry") ;;
        fix)      fixes+=("$entry") ;;
        refactor) refactors+=("$entry") ;;
        *)        other+=("$entry") ;;
    esac
done <<<"$commits"

section="$(
    printf '## %s - %s\n\n' "$VERSION" "$(date -u +%Y-%m-%d)"
    printf '_Changes since %s._\n' "$compared_to"

    emit() {
        local title="$1"; shift
        (($#)) || return 0
        printf '\n### %s\n\n' "$title"
        printf '%s\n' "$@"
    }
    if ((${#breaking[@]} + ${#features[@]} + ${#fixes[@]} + ${#refactors[@]} + ${#other[@]} == 0)); then
        printf '\n_No changes recorded._\n'
    fi
    emit 'Breaking changes' ${breaking+"${breaking[@]}"}
    emit 'Features'         ${features+"${features[@]}"}
    emit 'Fixes'            ${fixes+"${fixes[@]}"}
    emit 'Refactors'        ${refactors+"${refactors[@]}"}
    emit 'Other'            ${other+"${other[@]}"}
)"

printf '%s\n' "$section"

# Prepend, keeping the file's heading on top.
[[ -f "$CHANGELOG" ]] || printf '# Changelog\n' > "$CHANGELOG"
heading="$(head -1 "$CHANGELOG")"
rest="$(tail -n +2 "$CHANGELOG")"
{
    printf '%s\n\n' "$heading"
    printf '%s\n' "$section"
    [[ -n "${rest//[[:space:]]/}" ]] && printf '%s\n' "$rest"
} > "$CHANGELOG.tmp"
mv "$CHANGELOG.tmp" "$CHANGELOG"
