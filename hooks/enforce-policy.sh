#!/usr/bin/env bash
if [ "${AUTOPOIETICO_DISABLED:-0}" = "1" ] || [ "${CLAUDE_PLUGIN_OPTION_ENABLED:-true}" = "false" ]; then
  exit 0
fi

repo_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Opt-in check: Active only if target repo was initialized via /init (has kb/governance/constitution.md or .autopoietic/enabled) or is the plugin engine itself
if [ ! -f "$repo_dir/kb/governance/constitution.md" ] && [ ! -f "$repo_dir/.autopoietic/enabled" ] && [ ! -f "$repo_dir/.claude-plugin/plugin.json" ]; then
  exit 0
fi

# Run policy enforcement checks via Python
python3 -c '
import json, sys, re

SECRET_REGEX = re.compile(r"(sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{20,}|bearer\s+[a-zA-Z0-9\._\-]+)", re.IGNORECASE)

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

tool_input = data.get("tool_input", {})
file_path = str(tool_input.get("file_path") or tool_input.get("path") or "")
content = str(tool_input.get("content") or tool_input.get("new_string") or "")

# 1. Secret Leakage Prevention (Article 7)
if file_path.startswith("kb/") or file_path.startswith("core-kb/"):
    if SECRET_REGEX.search(content):
        res = {
            "continue": False,
            "systemMessage": "⚠️ Policy Violation (Article 7): Secret/API key pattern detected in write payload. Secrets must never enter kb/."
        }
        print(json.dumps(res))
        sys.exit(0)

# 2. OKF Frontmatter Validation on kb/ entries
if file_path.startswith("kb/") and file_path.endswith(".md") and not file_path.endswith("index.md"):
    if content.startswith("---"):
        parts = content.split("---", 2)
        if len(parts) >= 3:
            fm_text = parts[1]
            required_keys = ["id:", "title:", "description:", "status:"]
            missing = [k for k in required_keys if k not in fm_text]
            if missing:
                res = {
                    "continue": False,
                    "systemMessage": f"⚠️ Policy Violation (OKF Schema): kb/ file is missing required YAML frontmatter fields: {", ".join(missing)}"
                }
                print(json.dumps(res))
                sys.exit(0)
        else:
            res = {
                "continue": False,
                "systemMessage": "⚠️ Policy Violation (OKF Schema): kb/ file must contain valid --- YAML frontmatter --- header."
            }
            print(json.dumps(res))
            sys.exit(0)

# 3. Acceptance Criteria Validation on kb/improvements/ proposals
if "kb/improvements/proposal-" in file_path:
    if "## Acceptance criteria" not in content and "## Acceptance Criteria" not in content:
        res = {
            "continue": False,
            "systemMessage": "⚠️ Policy Violation (Article 6): Improvement proposals must include a ## Acceptance criteria section."
        }
        print(json.dumps(res))
        sys.exit(0)

# All checks passed cleanly
print(json.dumps({"continue": True}))
' 2>/dev/null || exit 0

exit 0
