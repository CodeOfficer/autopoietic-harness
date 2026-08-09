---
name: status
description: Displays autopoietic-harness plugin status, health metrics, telemetry count, review cooldown status, mode detection (Engine vs Consumer), and pending proposals.
---

# Autopoietic Harness: Status

## Purpose

Provide a comprehensive status and debugging dashboard for the Autopoietic Harness plugin in the current workspace.

## Initialization Guard (Prerequisite)

Before showing status, check if the current repository is initialized with Autopoietic Harness or is the plugin engine itself:
- Verify that `kb/governance/constitution.md`, `.autopoietic/enabled`, or `.claude-plugin/plugin.json` exists in `$CLAUDE_PROJECT_DIR`.
- **If NOT initialized**: Stop immediately and tell the owner:
  > ⚠️ **Autopoietic Harness is not initialized in this repository.**  
  > Please run `/autopoietic-harness:init` first to scaffold the local governance structure and knowledge base.

## Steps

1. **Context & Mode Detection**:
   - Check if `$CLAUDE_PROJECT_DIR/.claude-plugin/plugin.json` exists.
   - If present $\rightarrow$ **Mode: `[ENGINE MAINTAINER MODE]`** (Developing the plugin itself).
   - If absent $\rightarrow$ **Mode: `[CONSUMER REPOSITORY MODE]`** (Using the plugin in an application repo).

2. **Inspect Plugin Environment & Paths**:
   - Read `.claude-plugin/plugin.json` or active plugin metadata for version and settings (`enabled`, `quarantine_mode`, `plugin_source_path`, `event_threshold`, `cooldown_minutes`).
   - Compare `$CLAUDE_PROJECT_DIR` vs `$CLAUDE_PLUGIN_DIR` vs `CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH`.

3. **Check Telemetry & Ledger Health**:
   - Count events in `.autopoietic/friction/events.jsonl` and `.autopoietic/friction/events.pending.jsonl`.
   - Report secret redaction active status and log file size.

4. **Check Cooldown & Review Lock Status**:
   - Check if `.autopoietic/friction/.review.lock` exists.
   - If lock exists, display lock age (minutes) and status.

5. **Check Pending Proposals**:
   - Count pending items (`status: proposed`) in `kb/governance/amendments/`, `kb/improvements/`, and `.autopoietic/friction/proposals.json`.

6. **Display Dashboard**:
   Output clean Markdown table and status cards:
   - **Active Execution Mode**: `[ENGINE MAINTAINER MODE]` or `[CONSUMER REPOSITORY MODE]`
   - **Resolved Paths**: `$CLAUDE_PROJECT_DIR` and `$CLAUDE_PLUGIN_DIR`
   - **Plugin Status**: Active / Disabled
   - **Plugin Version & Config**: Settings & Thresholds
   - **Telemetry Events**: Event Counts & Context Tags
   - **Synthesis Review Cooldown**: Active / Idle
   - **Pending Proposals**: Count & List
