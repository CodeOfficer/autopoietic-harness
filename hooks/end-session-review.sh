#!/usr/bin/env bash
if [ "${AUTOPOIETICO_DISABLED:-0}" = "1" ] || [ "${AUTOPOIETICO_ENABLED:-true}" = "false" ] || [ "${CLAUDE_PLUGIN_OPTION_ENABLED:-true}" = "false" ]; then
  exit 0
fi

[ -n "${GOVERNANCE_REVIEW_HOOK:-}" ] && exit 0

repo_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
plugin_dir="${CLAUDE_PLUGIN_DIR:-${AUTOPOIETICO_PLUGIN_SOURCE_PATH:-${CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH:-$(cd "$(dirname "$0")/.." && pwd)}}}"

# Opt-in check: Active only if target repo was initialized via /init (has kb/governance/constitution.md or .autopoietic/enabled) or is the plugin engine itself
if [ ! -f "$repo_dir/kb/governance/constitution.md" ] && [ ! -f "$repo_dir/.autopoietic/enabled" ] && [ ! -f "$repo_dir/.claude-plugin/plugin.json" ]; then
  exit 0
fi

friction_dir="$repo_dir/.autopoietic/friction"
lock="$friction_dir/.review.lock"
log="$friction_dir/end-session-review.log"
events_file="$friction_dir/events.jsonl"
pending_file="$friction_dir/events.pending.jsonl"

cooldown_mins="${AUTOPOIETICO_COOLDOWN_MINUTES:-${CLAUDE_PLUGIN_OPTION_COOLDOWN_MINUTES:-60}}"
event_threshold="${AUTOPOIETICO_EVENT_THRESHOLD:-${CLAUDE_PLUGIN_OPTION_EVENT_THRESHOLD:-3}}"

quarantine_flag="${AUTOPOIETICO_QUARANTINE_MODE:-${CLAUDE_PLUGIN_OPTION_QUARANTINE_MODE:-false}}"

# Quarantine Mode: Global ~/.autopoietic/staging vs Local .autopoietic/staging
if [ "$quarantine_flag" = "true" ]; then
  repo_id=$(python3 -c '
import subprocess, hashlib, os, sys
cwd = sys.argv[1]
try:
    git_dir = subprocess.check_output(["git", "rev-parse", "--git-common-dir"], cwd=cwd, stderr=subprocess.DEVNULL, text=True).strip()
    abs_git_dir = os.path.abspath(os.path.join(cwd, git_dir))
    h = hashlib.sha256(abs_git_dir.encode()).hexdigest()[:12]
except Exception:
    h = hashlib.sha256(os.path.abspath(cwd).encode()).hexdigest()[:12]
print(f"{os.path.basename(cwd)}-{h}")
' "$repo_dir" 2>/dev/null || echo "$(basename "$repo_dir")")
  staging_dir="$HOME/.autopoietic/staging/$repo_id"
else
  staging_dir="$repo_dir/.autopoietic/staging"
fi

# 1. Configurable Cooldown Lock Check
if [ -d "$lock" ]; then
  if [ -n "$(find "$lock" -maxdepth 0 -mmin +"$cooldown_mins" 2>/dev/null)" ]; then
    rmdir "$lock" 2>/dev/null
  else
    # Lock is active and less than cooldown minutes old
    exit 0
  fi
fi

# 2. Configurable Minimum Event Threshold Check
count=0
if [ -f "$events_file" ]; then
  c1=$(wc -l < "$events_file" 2>/dev/null || echo 0)
  count=$((count + c1))
fi
if [ -f "$pending_file" ]; then
  c2=$(wc -l < "$pending_file" 2>/dev/null || echo 0)
  count=$((count + c2))
fi

if [ "$count" -lt "$event_threshold" ]; then
  exit 0
fi

# Acquire lock
mkdir -p "$friction_dir" "$staging_dir"
mkdir "$lock" 2>/dev/null || exit 0

# Rotate events into pending
if [ -s "$events_file" ]; then
  cat "$events_file" >> "$pending_file" && rm -f "$events_file"
fi

today="$(date +%F)"
prompt="You are the automated end-session reviewer. Perform BOTH duties in this one run.

1) Governance review, following $plugin_dir/core-kb/constitution.md and amendments: read kb/governance/constitution.md and every file in kb/governance/amendments/. If gaps or contradictions warrant it, write ONE file kb/governance/amendments/session-${today}.md (append -2, -3, ... if that name exists) with OKF frontmatter per core-kb/okf-format.md and status: proposed, and add it to the index there.

2) Friction synthesis, following core-kb/self-improvement.md: read .autopoietic/friction/events.pending.jsonl if it exists. Cluster recurring events by root cause. For each root cause, choose the cheapest fitting primitive per core-kb/primitive-selection.md and write kb/improvements/proposal-${today}-<slug>.md (status: proposed) stating the primitive, why cheaper ones don't suffice, the target tier (consumer-repo local or global plugin engine), and acceptance criteria. Materialize any executable artifact under $staging_dir/<proposal-id>/. Add each proposal to kb/improvements/index.md.

The ledger logs ONLY failures, so it cannot show that a later attempt succeeded. Before proposing anything from it, apply all three rules in core-kb/self-improvement.md stage 2: (a) iteration is not friction — repeated failures converging on a goal are the cost of the work; a pattern requires independent sessions, separated in time, doing unrelated work; (b) observation, not diagnosis — you have no shell and cannot verify why anything failed, so state the observed pattern and say the cause is unverified, never assert a root cause; (c) half-life test — a fact that would not survive a container rebuild is volatile state, not knowledge, and earns no kb entry at any tier; never propose anything that tells agents to stop checking something. When these rules leave nothing worth proposing, write nothing and say why.

Per constitution Article 4: for either duty, if nothing new emerged, write nothing for it and say so. Do not modify any other file. Do not apply any proposal. Do not run git commands."

# Detach execution
setsid bash -c '
  cd "$1" || exit 1
  deny="Bash"
  allow="Read,Glob,Grep,Edit(kb/governance/amendments/**),Edit(kb/improvements/**),Edit($6/**)"
  {
    echo "=== $(date -Is) end-session review starting"
    echo "--- effective grant: --model claude-sonnet-5 --disallowedTools $deny --allowedTools $allow"
    GOVERNANCE_REVIEW_HOOK=1 claude -p "$2" \
      --model claude-sonnet-5 \
      --disallowedTools "$deny" \
      --allowedTools "$allow"
    rc=$?
    [ "$rc" -eq 0 ] && rm -f "$5"
    echo "=== $(date -Is) end-session review finished (exit $rc)"
  } > "$3" 2>&1
  rmdir "$4" 2>/dev/null
' _ "$repo_dir" "$prompt" "$log" "$lock" "$pending_file" "$staging_dir" < /dev/null > /dev/null 2>&1 &

exit 0
