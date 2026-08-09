#!/usr/bin/env bash
if [ "${AUTOPOIETICO_DISABLED:-0}" = "1" ] || [ "${CLAUDE_PLUGIN_OPTION_ENABLED:-true}" = "false" ]; then
  echo '{"enabled": false}'
  exit 0
fi

repo_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
plugin_dir="${CLAUDE_PLUGIN_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"

python3 -c '
import os, json, glob, sys

repo_dir = sys.argv[1]
plugin_dir = sys.argv[2]
source_path_raw = os.environ.get("CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH", "")

is_maintainer = False
try:
    current_repo_path = os.path.realpath(repo_dir)
    if source_path_raw:
        configured_source_path = os.path.realpath(os.path.expanduser(source_path_raw))
        if current_repo_path == configured_source_path:
            is_maintainer = True
    if not is_maintainer:
        plugin_json = os.path.join(current_repo_path, ".claude-plugin", "plugin.json")
        if os.path.isfile(plugin_json):
            with open(plugin_json) as f:
                d = json.load(f)
                if d.get("name") == "autopoietic-harness":
                    is_maintainer = True
except Exception:
    pass

constitution_active = os.path.isfile(os.path.join(repo_dir, "kb", "governance", "constitution.md"))
enabled_flag = os.path.isfile(os.path.join(repo_dir, ".autopoietic", "enabled")) or is_maintainer

events_file = os.path.join(repo_dir, ".autopoietic", "friction", "events.jsonl")
events_count = 0
if os.path.isfile(events_file):
    try:
        with open(events_file) as f:
            events_count = sum(1 for _ in f)
    except Exception:
        pass

lock_active = os.path.isdir(os.path.join(repo_dir, ".autopoietic", "friction", ".review.lock"))

proposals_count = 0
for pattern in ["kb/improvements/proposal-*.md", "kb/governance/amendments/session-*.md"]:
    proposals_count += len(glob.glob(os.path.join(repo_dir, pattern)))

out = {
    "is_maintainer": is_maintainer,
    "constitution_active": constitution_active,
    "enabled": enabled_flag,
    "events_count": events_count,
    "lock_active": lock_active,
    "proposals_count": proposals_count,
    "repo_dir": repo_dir,
    "plugin_dir": plugin_dir
}
print(json.dumps(out))
' "$repo_dir" "$plugin_dir" 2>/dev/null || echo '{"is_maintainer": false, "constitution_active": false, "enabled": false, "events_count": 0, "lock_active": false, "proposals_count": 0}'

exit 0
