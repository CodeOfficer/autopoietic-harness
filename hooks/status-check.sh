#!/usr/bin/env bash
if [ "${AUTOPOIETICO_DISABLED:-0}" = "1" ] || [ "${AUTOPOIETICO_ENABLED:-true}" = "false" ] || [ "${CLAUDE_PLUGIN_OPTION_ENABLED:-true}" = "false" ]; then
  echo '{"enabled": false}'
  exit 0
fi

repo_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
plugin_dir="${CLAUDE_PLUGIN_DIR:-${AUTOPOIETICO_PLUGIN_SOURCE_PATH:-${CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH:-$(cd "$(dirname "$0")/.." && pwd)}}}"

python3 -c '
import os, json, glob, sys

repo_dir = sys.argv[1]
plugin_dir = sys.argv[2]

# Dynamic Single-Source-of-Truth Config Resolver
def resolve_config(repo_dir, plugin_dir):
    manifest_path = os.path.join(plugin_dir, ".claude-plugin", "plugin.json")
    user_config_schema = {}
    cfg = {}
    if os.path.isfile(manifest_path):
        try:
            with open(manifest_path) as f:
                d = json.load(f)
                user_config_schema = d.get("userConfig", {})
                for k, v in user_config_schema.items():
                    cfg[k] = v.get("default")
        except Exception:
            pass
    if not cfg:
        cfg = {
            "enabled": True,
            "quarantine_mode": False,
            "plugin_source_path": "~/code/autopoietic-harness",
            "event_threshold": 3,
            "cooldown_minutes": 60
        }

    # Tier 2: Check AUTOPOIETICO_<KEY> and CLAUDE_PLUGIN_OPTION_<KEY>
    for k in list(cfg.keys()):
        env_auto = f"AUTOPOIETICO_{k.upper()}"
        env_claude = f"CLAUDE_PLUGIN_OPTION_{k.upper()}"
        val = os.environ.get(env_auto) or os.environ.get(env_claude)
        if val is not None:
            stype = user_config_schema.get(k, {}).get("type", "string")
            if stype == "boolean":
                cfg[k] = (val.lower() == "true" or val == "1")
            elif stype == "integer":
                try: cfg[k] = int(val)
                except: pass
            else:
                cfg[k] = val

    if os.environ.get("AUTOPOIETICO_DISABLED") == "1":
        cfg["enabled"] = False

    # Tier 1: Local repo config override (.autopoietic/config.json)
    local_cfg_file = os.path.join(repo_dir, ".autopoietic", "config.json")
    if os.path.isfile(local_cfg_file):
        try:
            with open(local_cfg_file) as f:
                local_data = json.load(f)
                for k in cfg.keys():
                    if k in local_data:
                        cfg[k] = local_data[k]
        except Exception:
            pass

    # Dynamic Assumption for Engine Maintainer Mode
    if plugin_dir and os.path.realpath(repo_dir) == os.path.realpath(plugin_dir):
        cfg["plugin_source_path"] = repo_dir

    return cfg

cfg = resolve_config(repo_dir, plugin_dir)

if not cfg.get("enabled", True):
    print(json.dumps({"enabled": False}))
    sys.exit(0)

# Maintainer Mode Detection
is_maintainer = False
try:
    current_repo_path = os.path.realpath(repo_dir)
    source_path_raw = cfg.get("plugin_source_path", "")
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
    "enabled": True,
    "events_count": events_count,
    "event_threshold": cfg.get("event_threshold", 3),
    "cooldown_minutes": cfg.get("cooldown_minutes", 60),
    "quarantine_mode": cfg.get("quarantine_mode", False),
    "lock_active": lock_active,
    "proposals_count": proposals_count,
    "repo_dir": repo_dir,
    "plugin_dir": plugin_dir
}
print(json.dumps(out))
' "$repo_dir" "$plugin_dir" 2>/dev/null || echo '{"is_maintainer": false, "constitution_active": false, "enabled": true, "events_count": 0, "event_threshold": 3, "cooldown_minutes": 60, "quarantine_mode": false, "lock_active": false, "proposals_count": 0}'

exit 0
