---
name: init
description: Scaffolds a new repository with Autopoietic Harness governance structure (CLAUDE.md, kb/, constitution, .gitignore entries).
---

# Autopoietic Harness: Init

## Purpose

Initialize a target project repository with the Autopoietic Harness structure, setting up local governance state (`kb/`), local constitution copy, and friction ledger configuration without touching engine code.

## Steps

1. Check if target directory already has `kb/governance/constitution.md`. If present, report existing harness state and ask if re-initialization is desired.
2. Create standard directory structure & opt-in flag:
   - `kb/governance/`
   - `kb/governance/amendments/`
   - `kb/improvements/`
   - `.autopoietic/` (Unified plugin state directory)
   - `.autopoietic/enabled` (Opt-in flag enabling plugin hooks for this repository)
   - `.autopoietic/friction/` (Friction ledger directory)
   - `.autopoietic/staging/` (Inert quarantine for unratified proposal artifacts)
3. Copy starter templates from plugin directory (`$CLAUDE_PLUGIN_DIR/templates/` and `$CLAUDE_PLUGIN_DIR/core-kb/`):
   - `kb/governance/constitution.md` (from `$CLAUDE_PLUGIN_DIR/core-kb/constitution.md`)
   - `kb/index.md` (from `$CLAUDE_PLUGIN_DIR/templates/repo-kb-index.template.md`)
   - `kb/governance/index.md` (from `$CLAUDE_PLUGIN_DIR/templates/governance-index.template.md`)
   - `kb/governance/amendments/index.md` (from `$CLAUDE_PLUGIN_DIR/templates/amendments-index.template.md`)
   - `kb/improvements/index.md` (from `$CLAUDE_PLUGIN_DIR/templates/improvements-index.template.md`)
   - `CLAUDE.md` (merge or create using `$CLAUDE_PLUGIN_DIR/templates/CLAUDE.md.template`)
4. Ensure `.gitignore` in the target repository includes:
   - `.autopoietic/`
5. Report completion with summary of created files and next steps.
