# Autopoietic Harness: Testing & Demonstration Example Prompts

This document provides realistic example prompts to test and demonstrate **Autopoietic Harness** across both **Plugin Consumer** and **Plugin Maintainer** workflows.

---

## 🧪 Suite 1: Plugin Consumer Scenario (Application Repository)

Use these prompts when testing inside a target consumer project (e.g. `/home/code/projects/plugin-consumer`).

### Prompt 1.1: Initialize the Target Repository
```
/autopoietic-harness:init
```
**Expected Outcome**:
- Scaffolds `kb/governance/constitution.md`, `kb/index.md`, `CLAUDE.md`, `.autopoietic/enabled`, and updates `.gitignore` with `.autopoietic/`.
- Reports successful initialization.

---

### Prompt 1.2: Check Harness Health & Telemetry Status
```
/autopoietic-harness:status
```
**Expected Outcome**:
- Displays status card showing:
  - **Mode**: `[CONSUMER REPOSITORY MODE]`
  - **Plugin Status**: Active (`1.0.0`)
  - **Telemetry Count**: 0 events
  - **Synthesis Cooldown**: Idle
  - **Pending Proposals**: 0

---

### Prompt 1.3: Simulate Session Friction (Telemetry Logging)
```
Try running a non-existent bash command `npm run test:nonexistent-suite` to see what fails.
```
**Expected Outcome**:
- Tool fails with exit code.
- `hooks/log-friction.sh` asynchronously appends telemetry event to `.autopoietic/friction/events.jsonl` with secret redaction and payload filtering active.

---

### Prompt 1.4: Review & Ratify Improvements Locally
```
/autopoietic-harness:ratify
```
**Expected Outcome**:
- Scans `.autopoietic/friction/proposals.json` and `kb/improvements/`.
- Generates ELI5 cards with 📌 header, Bottom Line (ELI5), What changes, Why needed, Before vs After, Risks.
- Prompts owner to select **Option A: Adopt Locally (Target Repository)**.

---

## 🛠️ Suite 2: Plugin Engine Maintainer Scenario (Plugin Repository)

Use these prompts when developing or testing inside the plugin source directory (`/home/code/orca/workspaces/shuky-test/claude-plugin-conversion`).

### Prompt 2.1: Verify Engine Maintainer Status & Path Diagnostics
```
/autopoietic-harness:status
```
**Expected Outcome**:
- Displays status card showing:
  - **Mode**: `[ENGINE MAINTAINER MODE]`
  - **$CLAUDE_PROJECT_DIR**: `/home/code/orca/workspaces/shuky-test/claude-plugin-conversion`
  - **$CLAUDE_PLUGIN_DIR**: `/home/code/orca/workspaces/shuky-test/claude-plugin-conversion`
  - **Installed Hooks**: 5 active hooks (`SessionStart`, `PreToolUse`, `PostToolUseFailure`, `PermissionDenied`, `SessionEnd`)

---

### Prompt 2.2: Test Deterministic Policy Enforcement (PreToolUse Guard)
```
Try writing a file `kb/test-bad-entry.md` with missing YAML frontmatter description to see if policy enforcement blocks it.
```
**Expected Outcome**:
- `hooks/enforce-policy.sh` intercepts the `Write` payload before execution.
- Returns `⚠️ Autopoietic Policy Violation (OKF Schema): kb/ concept entry missing required frontmatter fields: description:`.
- Tool execution is physically blocked.

---

### Prompt 2.3: Test Upstream Maintainer Mode Promotion
```
/autopoietic-harness:ratify
```
**Expected Outcome**:
- Detects maintainer mode and offers **Option B: Promote Upstream (Maintainer Mode)**.
- Validates that `$CLAUDE_PROJECT_DIR` equals `$CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH` to prevent circular self-copy recursion.

---

## 📋 Quick Test Checklist

| Prompt | Target Repo | Key Verification Point |
|---|---|---|
| `/autopoietic-harness:status` (un-initialized) | Consumer | Displays `⚠️ Not initialized` warning and halts |
| `/autopoietic-harness:init` | Consumer | Scaffolds `.autopoietic/` and `kb/` |
| `/autopoietic-harness:status` (initialized) | Consumer | Displays `[CONSUMER REPOSITORY MODE]` |
| `/autopoietic-harness:status` | Engine | Displays `[ENGINE MAINTAINER MODE]` |
| Policy Enforcement Test | Engine/Consumer | Blocks invalid `kb/` frontmatter or secret write |
