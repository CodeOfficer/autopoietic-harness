#!/usr/bin/env bash
if [ "${AUTOPOIETICO_DISABLED:-0}" = "1" ] || [ "${CLAUDE_PLUGIN_OPTION_ENABLED:-true}" = "false" ]; then
  exit 0
fi

set -u
repo_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Opt-in check: Active only if target repo was initialized via /init (has kb/governance/constitution.md or .autopoietic/enabled) or is the plugin engine itself
if [ ! -f "$repo_dir/kb/governance/constitution.md" ] && [ ! -f "$repo_dir/.autopoietic/enabled" ] && [ ! -f "$repo_dir/.claude-plugin/plugin.json" ]; then
  exit 0
fi

friction_proposals="$repo_dir/.autopoietic/friction/proposals.json"

kb_files="$(grep -rl "^status: proposed" "$repo_dir/kb" 2>/dev/null | sed "s|^$repo_dir/||" || true)"

json_count=0
if [ -f "$friction_proposals" ]; then
  json_count=$(python3 -c '
import json, sys
try:
    data = json.load(open(sys.argv[1]))
    print(len([p for p in data if p.get("status") == "proposed"]))
except Exception:
    print(0)
' "$friction_proposals" 2>/dev/null || echo 0)
fi

kb_count=0
if [ -n "$kb_files" ]; then
  kb_count=$(printf '%s\n' "$kb_files" | wc -l | tr -d ' ')
fi

total=$((kb_count + json_count))

if [ "$total" -eq 0 ]; then
  exit 0
fi

list=""
if [ -n "$kb_files" ]; then
  list="$(printf '%s\n' "$kb_files" | paste -sd ', ' -)"
fi
if [ -n "$list" ]; then
  list="$list, .autopoietic/friction/proposals.json ($json_count item(s))"
else
  list=".autopoietic/friction/proposals.json ($json_count item(s))"
fi

printf '{"systemMessage": "%s proposal(s) awaiting ratification: %s — run /autopoietic-harness:ratify to review"}\n' "$total" "$list"
exit 0
