#!/usr/bin/env bash
if [ "${AUTOPOIETICO_DISABLED:-0}" = "1" ] || [ "${CLAUDE_PLUGIN_OPTION_ENABLED:-true}" = "false" ]; then
  exit 0
fi

repo_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
plugin_dir="${CLAUDE_PLUGIN_DIR:-${CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH:-$(cd "$(dirname "$0")/.." && pwd)}}"

# Opt-in check: Active only if target repo was initialized via /init (has kb/governance/constitution.md or .autopoietic/enabled) or is the plugin engine itself
if [ ! -f "$repo_dir/kb/governance/constitution.md" ] && [ ! -f "$repo_dir/.autopoietic/enabled" ] && [ ! -f "$repo_dir/.claude-plugin/plugin.json" ]; then
  exit 0
fi

prompt_file="$plugin_dir/system-prompt.md"

if [ -f "$prompt_file" ]; then
  prompt_content="$(cat "$prompt_file")"
else
  prompt_content="<autopoietic_harness_governance>This workspace is governed by Autopoietic Harness. Respect active constitution laws in kb/governance/constitution.md and report friction events.</autopoietic_harness_governance>"
fi

python3 -c '
import json, sys
msg = sys.argv[1]
out = {
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": msg
    }
}
print(json.dumps(out))
' "$prompt_content" 2>/dev/null

exit 0
