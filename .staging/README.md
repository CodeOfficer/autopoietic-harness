# Staging

Quarantine for artifacts carried by pending proposals: draft skills, hook scripts, settings diffs, kb concepts — whatever a proposal in `kb/improvements/` would install if adopted.

Nothing here is live. The harness loads skills only from `.claude/skills/` and hooks only from `.claude/settings.json`, so a file in this directory cannot execute or take effect no matter what it contains.

- One subdirectory per proposal: `.staging/<proposal-id>/`.
- Committed, so a proposal stays applyable and auditable weeks later.
- Deleted by the `ratify` skill when its proposal is decided, adopted or rejected.

See `kb/self-improvement.md` for the lifecycle.
