# Migration Specification: Single-Repo Harness to Universal Claude Code Plugin (V1)

## Executive Summary

This document specifies the architectural transition of **Autopoietic Harness** from a single-repository working harness (where hooks and skills resided in `.claude/hooks/` and `.claude/skills/`) to a universal, distributable **Claude Code Plugin** (`@codeofficer/autopoietic-harness`).

---

## 1. Architectural Architecture: Engine vs. State

| Component | Single-Repo (Legacy) | Universal Plugin (V1) |
|---|---|---|
| **Location** | `.claude/hooks/`, `.claude/skills/` | Plugin package (`hooks/`, `skills/`, `.claude-plugin/`) |
| **State Storage** | Embedded in local repo | Local repo (`kb/`, `.staging/`, `.claude/friction/`) |
| **System Prompt Injection** | Full file loaded continuously | Ultra-lean (<30 tokens) XML fenced injection (`<autopoietic_harness_governance>`) |
| **Slash Commands** | Unnamespaced (`/ratify`) | Namespaced (`/autopoietic-harness:ratify`, `/autopoietic-harness:status`, `/autopoietic-harness:init`, `/autopoietic-harness:migrate`) |
| **Kill Switch** | None | Instant line 2 check (`AUTOPOIETICO_DISABLED=1` / `CLAUDE_PLUGIN_OPTION_ENABLED=false`) |

---

## 2. Key Safeguards & Features

### A. Minimum Friction Architecture (MFA)
- **Zero-Latency Telemetry**: Telemetry appender (`hooks/log-friction.sh`) executes in subshells `(...) || true` exiting `0` in <1ms.
- **Debounced Synthesis Review**: SessionEnd reviews run headlessly only when pending un-synthesized friction events $\ge 3$ and cooldown lock $\ge 60$ minutes.
- **Privacy & Secret Redaction**: Stdin passed through regex filter stripping API keys (`sk-...`, `ghp_...`, `bearer ...`, passwords) before logging.
- **Payload Origin Filtering**: Automatically ignores non-harness third-party tools (e.g. `mcp__*`).

### B. Upstream Maintainer Mode
- Interactive ratification (`/autopoietic-harness:ratify`) allows the owner to select whether to adopt changes **locally** to the target repository or **promote upstream** to `$CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH` (`~/code/autopoietic-harness`).
- Background processes remain **100% local** and never modify upstream plugin code asynchronously.

---

## 3. Migration Steps for Legacy Workspaces

To upgrade a legacy single-repo harness workspace:

1. Enable the autopoietic-harness plugin in Claude Code.
2. Run the migration verb:
   ```bash
   /autopoietic-harness:migrate
   ```
3. The migration skill will:
   - Deactivate obsolete `.claude/hooks/` and `.claude/skills/`.
   - Backup `.claude/settings.json` to `.claude/settings.json.bak`.
   - Preserve local knowledge (`kb/`) and friction logs (`.claude/friction/`).
   - Validate plugin integration.

---

## 4. Verification & Testing

- Run `/autopoietic-harness:status` to verify plugin health, active version, telemetry stats, and review cooldown.
- Run `/autopoietic-harness:init` to scaffold a new target repository.
