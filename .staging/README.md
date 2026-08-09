# Staging

Quarantine for artifacts carried by pending proposals: draft skills, hook scripts, settings diffs, kb concepts — whatever a proposal in `kb/improvements/` would install if adopted.

Nothing here is live. The harness loads skills only from `.claude/skills/` and hooks only from `.claude/settings.json`, so a file in this directory cannot execute or take effect no matter what it contains.

- One subdirectory per proposal: `.staging/<proposal-id>/`.
- Committed, so a proposal stays applyable and auditable weeks later.
- Deleted by the `ratify` skill when its proposal is decided, adopted or rejected.

## Why this is not layered

Unlike `CLAUDE.md` and `kb/`, staging is deliberately repo-wide — projects do not get their own. Layering serves things consulted contextually by nearest-wins resolution; staging is addressed explicitly by one consumer (`ratify`), by proposal id, so layering would buy nothing and would split each proposal from its artifact.

Staging follows the **proposal queue**, not the proposal's target. A proposal targeting `projects/X/` still stages centrally, because the queue in `kb/improvements/` is central. Revisit only if that queue itself becomes per-project — then staging should split with it.

See `kb/self-improvement.md` for the lifecycle.
