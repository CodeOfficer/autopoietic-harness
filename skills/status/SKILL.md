---
name: status
description: Displays autopoietic-harness plugin status, health metrics, telemetry count, review cooldown status, and pending proposals.
---

# Autopoietic Harness: Status

## Purpose

Provide a comprehensive status dashboard for the Autopoietic Harness plugin in the current workspace.

## Initialization Guard (Prerequisite)

Before showing status, check if the current repository is initialized with Autopoietic Harness:
- Verify that `kb/governance/constitution.md` or `.claude/autopoietic-enabled` exists in the working repository root (`$CLAUDE_PROJECT_DIR`).
- **If NOT initialized**: Stop immediately and tell the owner:
  > ⚠️ **Autopoietic Harness is not initialized in this repository.**  
  > Please run `/autopoietic-harness:init` first to scaffold the local governance structure and knowledge base.

## Steps

1. **Inspect Plugin Environment**:
   - Read `.claude-plugin/plugin.json` or active plugin metadata for version and configuration settings (`enabled`, `quarantine_mode`, `plugin_source_path`).
   - Check environment variables (`AUTOPOIETICO_DISABLED`, `CLAUDE_PLUGIN_OPTION_ENABLED`).

2. **Check Telemetry & Ledger Health**:
   - Count events in `.claude/friction/events.jsonl` and `.claude/friction/events.pending.jsonl`.
   - Check secret redaction and log file size.

3. **Check Cooldown & Review Lock Status**:
   - Check if `.claude/friction/.review.lock` exists.
   - If lock exists, display lock age (minutes) and status.

4. **Check Pending Proposals**:
   - Count pending items (`status: proposed`) in `kb/governance/amendments/`, `kb/improvements/`, and `.claude/friction/proposals.json`.

5. **Display Dashboard**:
   Output clean Markdown table and status cards:
   - Plugin Status (Active / Disabled / Uninitialized)
   - Plugin Version & Config
   - Telemetry Events (Raw & Pending)
   - Synthesis Review Cooldown Status
   - Pending Proposals Count & List
