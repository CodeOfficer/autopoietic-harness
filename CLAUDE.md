# Repository Rules

This repository is a playground for a spec-driven, AI product-development-lifecycle agent-coding system.

## Governing rule

Every directory follows the nearest `CLAUDE.md` found in its own directory or an ancestor directory. A more-local `CLAUDE.md` supplements the root rules and, where they conflict, takes precedence for its subtree.

## Layered knowledge

Knowledge lives in layered `kb/` directories (Open Knowledge Format — see `kb/okf-format.md`). A more-local `kb/` supplements and, when relevant, takes precedence over broader knowledge. Start discovery at the nearest `kb/index.md`, then walk up. See `kb/layered-knowledge.md`.

## Conventions

- Before adopting any convention not clearly implied by existing repository files, ask the repository owner first.
- Keep every file short, focused, and single-purpose.
- On recurring friction (repeated failures, guessed conventions, retries), append a one-line JSON note to `.claude/friction/events.jsonl` (see `kb/self-improvement.md`).
- OKF concept files use the frontmatter schema defined in `kb/okf-format.md`.

## Layout

- `core-kb/` — baseline governance and OKF concepts shipped with the plugin
- `hooks/` — engine lifecycle hook scripts
- `skills/` — namespaced interactive verbs (`ratify`, `init`, `status`, `migrate`)
- `templates/` — scaffolding templates for `/init`
- `.claude-plugin/` — plugin manifest (`plugin.json`) and lifecycle bindings (`hooks.json`)
- `kb/` — repository governance and local knowledge base
- `.autopoietic/` — local plugin state (friction telemetry ledger, staging quarantine, enabled flag)


