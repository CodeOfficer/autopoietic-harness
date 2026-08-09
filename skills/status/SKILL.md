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

1. **Execute Fast Status Check (One Silent Pass)**:
   - Run the status check script:
     ```bash
     "${CLAUDE_PLUGIN_DIR:-.}"/hooks/status-check.sh
     ```
   - Parse the JSON response containing `is_maintainer`, `constitution_active`, `enabled`, `events_count`, `lock_active`, and `proposals_count`.

2. **Format Output Based on Mode**:

   ### A. If `is_maintainer` is FALSE (Project Workspace / Consumer Mode):
   Output ONLY an ultra-clean, minimal summary table:

   ```markdown
   # Autopoietic Harness — Status

   | Component | Status |
   |---|---|
   | **Plugin** | ✅ Active (v1.0.0) |
   | **Constitution** | ✅ `kb/governance/constitution.md` |
   | **Friction Log** | 📊 <events_count> events logged |
   | **Automated Review** | 🟢 Idle / 🔒 Cooldown active |
   | **Pending Proposals** | 📥 <proposals_count> proposals awaiting ratification |
   ```

   *Omit all maintainer mode banners, environment path tables ($CLAUDE_PLUGIN_DIR), and maintainer config debug tables.*

   ### B. If `is_maintainer` is TRUE (Plugin Engine Repository):
   Output the comprehensive Maintainer Status Dashboard:

   ```markdown
   # Autopoietic Harness — Maintainer Status Dashboard

   🛠️ **`[ENGINE MAINTAINER MODE]`**

   ## 📂 Path & Environment Diagnostics
   - Working Directory (`$CLAUDE_PROJECT_DIR`): `<repo_dir>`
   - Plugin Directory (`$CLAUDE_PLUGIN_DIR`): `<plugin_dir>`

   ## ⚡ Plugin Status & Configuration
   - Plugin Version: `1.0.0`
   - Active Constitution: ✅ `kb/governance/constitution.md`

   ## 📊 Friction Log & Ledger Health
   - Un-synthesized events: `<events_count>`
   - Secret Redaction: Active

   ## ⏱️ Automated Review Status
   - Review Lock: `<lock_active>`

   ## 📥 Pending Proposals Manifest
   - Pending proposals: `<proposals_count>`
   ```
