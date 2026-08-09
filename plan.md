# Master Execution Plan: Conversion to Autopoietic Harness Claude Plugin

> **Destination Worktree**: `/home/code/orca/workspaces/shuky-test/claude-plugin-conversion`  
> **Target Package**: `@codeofficer/autopoietic-harness` (Claude Code Plugin)  
> **Goal**: Convert this blended repository into a pure, distributable Claude Code Plugin with a clean separation of **Engine (Plugin)** vs. **State (Repository)**.

---

## 1. Architectural Principles & Q&A Decisions

This plan incorporates all architectural discoveries, multi-plugin isolation rules, and friction mitigations established during system design Q&A:

1. **Engine vs. State Division**:
   - **The Plugin (ENGINE)**: Contains hook scripts, interactive skills (`/ratify`, `/init`, `/status`, `/migrate`), synthesis prompts, system prompt injection, and schema adapters.
   - **The Repository (STATE)**: Contains the active Constitution (`kb/governance/constitution.md`), domain knowledge (`kb/*.md`), pending proposals (`kb/improvements/`), staged diffs (`.staging/`), and local friction logs.

2. **Minimum Friction Architecture (MFA)**:
   - **Ultra-Lean System Prompt Injection**: Injects <30 tokens at session start (`SessionStart`) using XML fencing `<autopoietic_harness_governance>`.
   - **Zero-Latency Telemetry**: `log-friction.sh` executes asynchronously in subshells (`(...) || true`) and exits `0` in <1ms.
   - **Debounced Synthesis Engine**: Headless `SessionEnd` review triggers **only if**:
     1. Un-synthesized friction events $\ge 3$.
     2. No review ran in the last 60 minutes (`cooldown_seconds: 3600`).
   - **Git-Pristine Pending Queue**: Unratified proposals stay in local gitignored friction cache (`.claude/friction/proposals.json`). Only ratified changes enter Git.

3. **Multi-Plugin Isolation & Coexistence**:
   - **Payload Filtering**: `log-friction.sh` ignores third-party tool failures (e.g. `mcp__*` tools or external plugin errors).
   - **Defensive Subshell Fencing**: All hooks wrap logic in subshells with explicit exit `0` guarantees.
   - **Prompt Fencing**: System prompt instructions are wrapped in `<autopoietic_harness_governance>` tags to prevent persona/prompt pollution with other plugins.
   - **Command Namespacing**: Manifest namespacing ensures all slash commands use `/autopoietic-harness:<verb>`.

4. **Master Bypass / Kill Switch**:
   - Every hook script checks `AUTOPOIETICO_DISABLED=1` or `AUTOPOIETICO_DISABLED=true` (or `CLAUDE_PLUGIN_OPTION_ENABLED=false`) as line 2 of execution for an instant <1ms bypass exit.

5. **Strict Locality & Maintainer Upstream Mode**:
   - **Background `SessionEnd` is 100% LOCAL**: It NEVER touches external directories or upstream plugin code in the background. Zero cross-repo background locks.
   - **Upstream Promotion is Interactive**: Upstream graduation to `~/code/autopoietic-harness` happens **only** when the maintainer interactively selects "Promote Upstream" inside `/autopoietic-harness:ratify`.

6. **Privacy & Telemetry Redaction (Constitution Article 7)**:
   - `log-friction.sh` automatically passes stdin through a secret-redaction regex filter stripping API keys (`sk-...`, `ghp_...`, `bearer ...`, passwords) before appending to `.claude/friction/events.jsonl`.

---

## 2. Target Directory Layout

```
/home/code/orca/workspaces/shuky-test/claude-plugin-conversion/
├── .claude-plugin/
│   ├── plugin.json                 # Manifest: name, version, userConfig parameters
│   └── hooks.json                  # Lifecycle bindings (SessionStart, PostToolUseFailure, etc.)
├── system-prompt.md                # Lean XML-fenced system prompt injection (<30 tokens)
├── hooks/                          # Engine Executable Scripts
│   ├── pending-proposals.sh        # SessionStart: checks ratification queues
│   ├── log-friction.sh             # Telemetry: payload-filtered & redacted friction logger
│   └── end-session-review.sh       # Synthesis: debounced background reviewer (claude -p)
├── skills/                         # Namespaced Interactive Verbs
│   ├── ratify/
│   │   └── SKILL.md                # /autopoietic-harness:ratify (with Maintainer Upstream option)
│   ├── status/
│   │   └── SKILL.md                # /autopoietic-harness:status (health & telemetry dashboard)
│   ├── init/
│   │   └── SKILL.md                # /autopoietic-harness:init (scaffolds target repo kb/)
│   └── migrate/
│       └── SKILL.md                # /autopoietic-harness:migrate (converts legacy single-repo harness)
├── core-kb/                        # Shipped Baseline OKF Concepts
│   ├── constitution.md             # The 7 Constitutional Laws
│   ├── self-improvement.md         # 4-stage lifecycle & non-false-knowledge rules
│   ├── primitive-selection.md      # Cheapest primitive rubric
│   ├── okf-format.md               # OKF YAML frontmatter schema
│   └── layered-knowledge.md        # Nearest-wins resolution rules
├── templates/                      # Scaffolding Templates for /init & /migrate
│   ├── CLAUDE.md.template
│   └── repo-kb-index.template.md
└── docs/
    └── MIGRATION-V1.md             # 1-time architectural conversion spec
```

---

## 3. Step-by-Step Execution Plan

### Task 1: Deactivate Legacy Hooks (Prevent Interference)
- Rename `.claude/settings.json` to `.claude/settings.json.bak` so local background review scripts don't fire during the refactoring process.

### Task 2: Build Plugin Manifest & Hooks Config
- Create `.claude-plugin/plugin.json`:
  - `name`: `"autopoietic-harness"`
  - `version`: `"1.0.0"`
  - `userConfig`: `enabled` (default `true`), `quarantine_mode` (default `false`), `plugin_source_path` (default `~/code/autopoietic-harness`).
- Create `.claude-plugin/hooks.json`:
  - Bind `SessionStart` $\rightarrow$ `hooks/session-start-prompt.sh` & `hooks/pending-proposals.sh`.
  - Bind `PostToolUseFailure` & `PermissionDenied` $\rightarrow$ `hooks/log-friction.sh` (`"async": true`).
  - Bind `SessionEnd` $\rightarrow$ `hooks/end-session-review.sh` (`"async": true`).

### Task 3: Refactor Engine Hooks (`hooks/`)
1. **`hooks/session-start-prompt.sh`**:
   - Outputs XML-fenced `<autopoietic_harness_governance>` prompt injection (<30 tokens).
2. **`hooks/log-friction.sh`**:
   - Move from `.claude/hooks/log-friction.sh`.
   - Add line 2 bypass check: `[ "${AUTOPOIETICO_DISABLED:-0}" = "1" ] && exit 0`.
   - Add secret redaction filter for API keys & passwords.
   - Add tool payload origin filter: ignore `mcp__*` and non-harness tools.
   - Wrap python telemetry appender in `(...) 2>/dev/null || true` subshell exiting `0`.
3. **`hooks/end-session-review.sh`**:
   - Move from `.claude/hooks/end-session-review.sh`.
   - Add line 2 bypass check.
   - Add **60-minute cooldown lock check** (`.review.lock` timestamp check).
   - Add **Minimum Event Threshold Check** ($\ge 3$ pending events).
   - Update `claude -p` execution parameters to point to `$CLAUDE_PLUGIN_DIR`.
4. **`hooks/pending-proposals.sh`**:
   - Move from `.claude/hooks/pending-proposals.sh`.
   - Check local project `kb/` and `~/.claude/friction/proposals.json` for pending items.

### Task 4: Refactor & Author Plugin Skills (`skills/`)
1. **`skills/ratify/SKILL.md`**:
   - Move from `.claude/skills/ratify/SKILL.md`.
   - Add ELI5 card manifest generation.
   - Add **Upstream Maintainer Mode Option**: Allow adopting changes locally to target repo OR copying staged artifacts directly to `$CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH`.
2. **`skills/init/SKILL.md`**:
   - Scaffolds a new repository with `CLAUDE.md`, `kb/governance/constitution.md`, `kb/index.md`, and `.gitignore` entries for `.claude/friction/`.
3. **`skills/status/SKILL.md`**:
   - Displays harness health: active plugin version, telemetry event stats, cooldown status, and pending proposals.
4. **`skills/migrate/SKILL.md`**:
   - Upgrades legacy single-repo harness environments into plugin-compatible workspaces by cleaning up obsolete `.claude/hooks/` and configuring `kb/`.

### Task 5: Organize Core Knowledge & Templates
- Move core OKF concepts (`constitution.md`, `self-improvement.md`, `primitive-selection.md`, `okf-format.md`, `layered-knowledge.md`) into `core-kb/`.
- Create starter templates under `templates/` for `/autopoietic-harness:init`.

### Task 6: Cleanup Legacy `.claude/` Engine Artifacts
- Remove old `.claude/hooks/` and `.claude/skills/` directories in the root worktree (they are now cleanly in `hooks/` and `skills/`).
- Keep `.claude/friction/` in `.gitignore`.

### Task 7: Create Migration Documentation & Marketplace Specs
- Author `docs/MIGRATION-V1.md` documenting the transition from single-repo `.claude/` harness to universal plugin architecture.
- Author `marketplace.json` template for team distribution.

### Task 8: Verification & Local Testing
- Test manifest syntax.
- Test local symlink loading: `ln -s /home/code/orca/workspaces/shuky-test/claude-plugin-conversion ~/.claude/plugins/autopoietic-harness`.
- Verify `/autopoietic-harness:status`, `/autopoietic-harness:ratify`, `/autopoietic-harness:init`, and `/autopoietic-harness:migrate` in a test session.

---

## 4. Key Code Specifications

### A. `.claude-plugin/plugin.json`
```json
{
  "name": "autopoietic-harness",
  "version": "1.0.0",
  "description": "Additive self-improving AI governance harness and layered knowledge engine",
  "author": {
    "name": "CodeOfficer"
  },
  "userConfig": {
    "enabled": {
      "description": "Master kill switch (true/false)",
      "default": "true"
    },
    "quarantine_mode": {
      "description": "Stage proposals in global ~/.claude/autopoietic/staging instead of repo .staging/ (true/false)",
      "default": "false"
    },
    "plugin_source_path": {
      "description": "Path to autopoietic-harness plugin repository for Maintainer Mode",
      "default": "~/code/autopoietic-harness"
    }
  }
}
```

### B. Telemetry Redaction (`hooks/log-friction.sh`)
```bash
#!/usr/bin/env bash
if [ "${AUTOPOIETICO_DISABLED:-0}" = "1" ] || [ "${CLAUDE_PLUGIN_OPTION_ENABLED:-true}" = "false" ]; then
  exit 0
fi

repo_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
mkdir -p "$repo_dir/.claude/friction"

# Subshell wrapper with secret redaction regex
(
  python3 -c '
import json, sys, datetime, re

# Secret redaction pattern (API keys, bearer tokens, passwords)
SECRET_REGEX = re.compile(r"(sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{20,}|bearer\s+[a-zA-Z0-9\._\-]+|password=[\"\x27][^\"\x27]+[\"\x27])", re.IGNORECASE)

try:
    d = json.load(sys.stdin)
except Exception:
    d = {}

tool_name = d.get("tool_name", "")
# Payload origin filter: ignore third-party MCP tools
if tool_name.startswith("mcp__"):
    sys.exit(0)

detail_str = str(d.get("tool_response") or d.get("reason") or d.get("tool_input") or "")
redacted_detail = SECRET_REGEX.sub("[REDACTED_SECRET]", detail_str)[:2000]

out = {
    "ts": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
    "event": sys.argv[1],
    "session": d.get("session_id"),
    "tool": tool_name,
    "detail": redacted_detail if redacted_detail else None,
}
print(json.dumps(out, default=str))
' "${1:-unknown}" >> "$repo_dir/.claude/friction/events.jsonl"
) 2>/dev/null || true

exit 0
```

---

## 5. Verification Checklist

- [ ] `.claude-plugin/plugin.json` valid JSON and follows kebab-case naming.
- [ ] `.claude-plugin/hooks.json` cleanly routes all lifecycle events.
- [ ] All hook scripts contain line 2 `AUTOPOIETICO_DISABLED` bypass check.
- [ ] `log-friction.sh` filters out `mcp__*` tools and redacts secrets.
- [ ] `end-session-review.sh` enforces 60-minute cooldown and $\ge 3$ event threshold.
- [ ] `/autopoietic-harness:ratify` includes Maintainer Upstream Option.
- [ ] `/autopoietic-harness:init` and `/autopoietic-harness:migrate` skills functional.
- [ ] Legacy `.claude/hooks` and `.claude/skills` cleanly refactored.
- [ ] `docs/MIGRATION-V1.md` written and committed.
