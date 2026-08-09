---
name: migrate
description: Upgrades a legacy single-repo harness workspace into a clean autopoietic-harness plugin workspace.
---

# Autopoietic Harness: Migrate

## Purpose

Upgrade legacy single-repo harness setups (which placed hook scripts and skills in `.claude/hooks/` and `.claude/skills/`) to the universal `@codeofficer/autopoietic-harness` plugin architecture.

## Prerequisite Check

1. Check if the active repository has legacy harness artifacts (`.claude/hooks/`, `.claude/skills/`, or `.claude/settings.json`).
2. **If NO legacy harness artifacts exist**:
   - Inform the owner:
     > ⚠️ **No legacy harness detected.**  
     > This repository does not contain a legacy single-repo harness setup.  
     > Run `/autopoietic-harness:init` to set up a new Autopoietic Harness workspace.

## Steps

1. **Detect Legacy Files**:
   - Inspect `.claude/hooks/` and `.claude/skills/` in the active repository.
   - Inspect `.claude/settings.json`.

2. **Backup & Deactivate Legacy Hooks**:
   - Rename `.claude/settings.json` to `.claude/settings.json.bak` if not already done.
   - Archive or remove obsolete `.claude/hooks/` (`end-session-review.sh`, `log-friction.sh`, `pending-proposals.sh`).
   - Archive or remove legacy `.claude/skills/` (`governance-convention`, `ratify`, `skill-authoring`).

3. **Preserve & Migrate Repository State (KB & Opt-In)**:
   - Ensure local `kb/` (`constitution.md`, amendments, improvements) remains intact in the repository root.
   - Migrate any existing `.claude/friction/` logs to `.autopoietic/friction/`.
   - Create `.autopoietic/enabled` opt-in flag.
   - Ensure `.gitignore` includes `.autopoietic/`.

4. **Verify Plugin Integration**:
   - Ensure plugin manifest and hook bindings are active.

5. **Report Migration Summary**:
   - Display list of cleaned legacy files.
   - Confirm active plugin hooks and skills state.
