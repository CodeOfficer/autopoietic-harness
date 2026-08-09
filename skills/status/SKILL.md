---
name: status
description: Displays autopoietic-harness plugin status, health metrics, telemetry count, review cooldown status, mode detection (Engine vs Consumer), and pending proposals.
---

# Autopoietic Harness: Status

## Purpose

Provide a status dashboard for the Autopoietic Harness plugin in the current workspace, adapting output between Consumer Mode (noise-free summary) and Maintainer Mode (full diagnostics).

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

2. **Collect Health & Telemetry Metrics**:
   - Verify `kb/governance/constitution.md` and `.autopoietic/enabled`.
   - Count events in `.autopoietic/friction/events.jsonl` and `.autopoietic/friction/events.pending.jsonl`.
   - Check if `.autopoietic/friction/.review.lock` exists (cooldown status).
   - Count pending items (`status: proposed`) in `kb/governance/amendments/`, `kb/improvements/`, and `.autopoietic/friction/proposals.json`.

3. **Format Output Based on Mode**:

   ### A. If in CONSUMER REPOSITORY MODE:
   Output ONLY an ultra-clean, minimal summary table:

   ```markdown
   # Autopoietic Harness — Status

   | Component | Status |
   |---|---|
   | **Plugin** | ✅ Active (v1.0.0) |
   | **Constitution** | ✅ `kb/governance/constitution.md` |
   | **Telemetry Ledger** | 📊 <count> events logged |
   | **Synthesis Review** | 🟢 Idle / 🔒 Cooldown active |
   | **Pending Proposals** | 📥 <count> proposals awaiting ratification |
   ```

   *Omit all maintainer mode banners, environment path tables ($CLAUDE_PLUGIN_DIR), and maintainer config debug tables.*

   ### B. If in ENGINE MAINTAINER MODE:
   Output the comprehensive Maintainer Status Dashboard:

   ```markdown
   # Autopoietic Harness — Maintainer Status Dashboard

   🛠️ **`[ENGINE MAINTAINER MODE]`**

   ## 📂 Path & Environment Diagnostics
   - `$CLAUDE_PROJECT_DIR`: <path>
   - `$CLAUDE_PLUGIN_DIR`: <path>
   - `CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH`: <path>

   ## ⚡ Plugin Status & Configuration
   - Plugin Version & Name
   - UserConfig settings & environment overrides (`quarantine_mode`, `event_threshold`, `cooldown_minutes`)

   ## 📊 Telemetry & Ledger Health
   - `.autopoietic/friction/events.jsonl` event count & file sizes
   - Secret redaction status

   ## ⏱️ Synthesis Review Cooldown
   - Review lock status & lock age

   ## 📥 Pending Proposals Manifest
   - Pending amendments, improvements, and staged artifacts count & list
   ```
