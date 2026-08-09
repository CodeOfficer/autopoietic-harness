#!/usr/bin/env bash
if [ "${AUTOPOIETICO_DISABLED:-0}" = "1" ] || [ "${CLAUDE_PLUGIN_OPTION_ENABLED:-true}" = "false" ]; then
  exit 0
fi

repo_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Opt-in check: Active only if target repo was initialized via /init (has kb/governance/constitution.md or .autopoietic/enabled) or is the plugin engine itself
if [ ! -f "$repo_dir/kb/governance/constitution.md" ] && [ ! -f "$repo_dir/.autopoietic/enabled" ] && [ ! -f "$repo_dir/.claude-plugin/plugin.json" ]; then
  exit 0
fi

mkdir -p "$repo_dir/.autopoietic/friction"

(
  python3 -c '
import json, sys, datetime, re, os

SECRET_REGEX = re.compile(r"(sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{20,}|bearer\s+[a-zA-Z0-9\._\-]+|password=[\"\x27]?[^\"\x27\s]+[\"\x27]?)", re.IGNORECASE)

try:
    d = json.load(sys.stdin)
except Exception:
    d = {}

tool_name = str(d.get("tool_name") or d.get("tool") or "")
if tool_name.startswith("mcp__"):
    sys.exit(0)

detail_str = str(d.get("tool_response") or d.get("reason") or d.get("tool_input") or "")
redacted_detail = SECRET_REGEX.sub("[REDACTED_SECRET]", detail_str)[:2000]

repo_dir = sys.argv[2]
is_engine = os.path.exists(os.path.join(repo_dir, ".claude-plugin", "plugin.json"))
context_tag = "engine_maintainer" if is_engine else "consumer"

out = {
    "ts": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
    "event": sys.argv[1],
    "session": d.get("session_id"),
    "context": context_tag,
    "tool": tool_name if tool_name else None,
    "detail": redacted_detail if redacted_detail else None,
}
print(json.dumps(out, default=str))
' "${1:-unknown}" "$repo_dir" >> "$repo_dir/.autopoietic/friction/events.jsonl"
) 2>/dev/null || true

exit 0
