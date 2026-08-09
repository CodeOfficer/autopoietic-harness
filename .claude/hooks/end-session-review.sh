#!/usr/bin/env bash
# SessionEnd hook: run the automated end-session review (governance + friction synthesis) headlessly.
# Proposals land in kb/governance/amendments/ and kb/improvements/ for owner review; nothing is auto-adopted.
set -u

# Recursion guard: the headless review session fires SessionEnd too.
[ -n "${GOVERNANCE_REVIEW_HOOK:-}" ] && exit 0

repo_dir="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
hooks_dir="$repo_dir/.claude/hooks"
lock="$hooks_dir/.review.lock"
log="$hooks_dir/end-session-review.log"
friction="$repo_dir/.claude/friction"
pending="$friction/events.pending.jsonl"

# One review at a time; a held lock means a review is already running.
# A lock older than 60 min is from a crashed review — reclaim it.
if [ -d "$lock" ] && [ -n "$(find "$lock" -maxdepth 0 -mmin +60 2>/dev/null)" ]; then
  rmdir "$lock" 2>/dev/null
fi
mkdir "$lock" 2>/dev/null || exit 0

# Rotate the friction ledger; pending accumulates until a review succeeds.
if [ -s "$friction/events.jsonl" ]; then
  cat "$friction/events.jsonl" >> "$pending" && rm -f "$friction/events.jsonl"
fi

today="$(date +%F)"
prompt="You are the automated end-session reviewer. Perform BOTH duties in this one run.

1) Governance review, following .claude/skills/governance-convention/SKILL.md in end-session review mode: read kb/governance/constitution.md and every file in kb/governance/amendments/. If gaps or contradictions warrant it, write ONE file kb/governance/amendments/session-${today}.md (append -2, -3, ... if that name exists) with OKF frontmatter per kb/okf-format.md and status: proposed, and add it to the index there.

2) Friction synthesis, following kb/self-improvement.md: read .claude/friction/events.pending.jsonl if it exists. Cluster recurring events by root cause. For each root cause, choose the cheapest fitting primitive per kb/primitive-selection.md and write kb/improvements/proposal-${today}-<slug>.md (status: proposed) stating the primitive, why cheaper ones don't suffice, the target tier (project-local unless graduation evidence: ratified in >=2 projects, or a stated project-agnostic argument), and acceptance criteria. Materialize any executable artifact under .staging/<proposal-id>/. Add each proposal to kb/improvements/index.md.

The ledger logs ONLY failures, so it cannot show that a later attempt succeeded. Before proposing anything from it, apply all three rules in kb/self-improvement.md stage 2: (a) iteration is not friction — repeated failures converging on a goal are the cost of the work; a pattern requires independent sessions, separated in time, doing unrelated work; (b) observation, not diagnosis — you have no shell and cannot verify why anything failed, so state the observed pattern and say the cause is unverified, never assert a root cause; (c) half-life test — a fact that would not survive a container rebuild is volatile state, not knowledge, and earns no kb entry at any tier; never propose anything that tells agents to stop checking something. When these rules leave nothing worth proposing, write nothing and say why.

Per constitution Article 4: for either duty, if nothing new emerged, write nothing for it and say so. Do not modify any other file. Do not apply any proposal. Do not run git commands."

# Detach so session exit is not blocked; the child cleans up the lock.
setsid bash -c '
  cd "$1" || exit 1
  # Single source of truth for the grant: logged and passed from the same variables,
  # so the log can never claim a containment the run did not actually receive (Art. 7).
  deny="Bash"
  allow="Read,Glob,Grep,Edit(kb/governance/amendments/**),Edit(kb/improvements/**),Edit(.staging/**)"
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
' _ "$repo_dir" "$prompt" "$log" "$lock" "$pending" < /dev/null > /dev/null 2>&1 &

exit 0
