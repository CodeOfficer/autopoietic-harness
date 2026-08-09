#!/usr/bin/env bash
# SessionStart hook: surface how many proposals await ratification.
set -u
repo_dir="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
files="$(grep -rl "^status: proposed" "$repo_dir/kb" 2>/dev/null | sed "s|^$repo_dir/||")"
[ -z "$files" ] && exit 0
n="$(printf '%s\n' "$files" | wc -l | tr -d ' ')"
list="$(printf '%s\n' "$files" | paste -sd ', ' -)"
printf '{"systemMessage": "%s proposal(s) awaiting ratification: %s — run /ratify to review"}\n' "$n" "$list"
exit 0
