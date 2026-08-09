#!/usr/bin/env bash
# SessionEnd hook: run the governance-convention end-session review headlessly.
# Proposals land in kb/governance/amendments/ for owner review; nothing is auto-adopted.
set -u

# Recursion guard: the headless review session fires SessionEnd too.
[ -n "${GOVERNANCE_REVIEW_HOOK:-}" ] && exit 0

repo_dir="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
hooks_dir="$repo_dir/.claude/hooks"
lock="$hooks_dir/.review.lock"
log="$hooks_dir/end-session-review.log"

# One review at a time; a held lock means a review is already running.
mkdir "$lock" 2>/dev/null || exit 0

today="$(date +%F)"
prompt="Follow .claude/skills/governance-convention/SKILL.md in end-session review mode.
Read kb/governance/constitution.md and every file in kb/governance/amendments/.
Identify gaps, contradictions, and proposed improvements to the constitution and to the convention itself, and draft concise proposed amendments with grounding per the skill.
Write ONE new file kb/governance/amendments/session-${today}.md (append -2, -3, ... if that name exists) with OKF frontmatter per kb/okf-format.md and status: proposed, then add it to the Sessions list in kb/governance/amendments/index.md marked proposed.
Do not modify any other file. Do not apply any proposal. Do not run git commands. If nothing new emerged since the latest session file, write no file and say so."

# Detach so session exit is not blocked; the child cleans up the lock.
setsid bash -c '
  cd "$1" || exit 1
  {
    echo "=== $(date -Is) end-session review starting"
    GOVERNANCE_REVIEW_HOOK=1 claude -p "$2" \
      --allowedTools "Read,Glob,Grep,Write(kb/governance/amendments/**),Edit(kb/governance/amendments/**)"
    echo "=== $(date -Is) end-session review finished (exit $?)"
  } >> "$3" 2>&1
  rmdir "$4" 2>/dev/null
' _ "$repo_dir" "$prompt" "$log" "$lock" < /dev/null > /dev/null 2>&1 &

exit 0
