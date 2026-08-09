#!/usr/bin/env bash
# Append one friction event (hook stdin JSON) to the gitignored ledger.
# Usage: log-friction.sh <event-name>   (wired to PostToolUseFailure / PermissionDenied)
set -u
repo_dir="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
mkdir -p "$repo_dir/.claude/friction"
python3 -c '
import json, sys, datetime
try:
    d = json.load(sys.stdin)
except Exception:
    d = {}
out = {
    "ts": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
    "event": sys.argv[1],
    "session": d.get("session_id"),
    "tool": d.get("tool_name"),
    "detail": d.get("tool_response") or d.get("reason") or d.get("tool_input") or None,
}
print(json.dumps(out, default=str)[:2000])
' "${1:-unknown}" >> "$repo_dir/.claude/friction/events.jsonl"
exit 0
