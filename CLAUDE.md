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

- `kb/` — repository-wide knowledge base
- `kb/governance/` — AI-governance constitution and proposed amendments
- `projects/` — individual projects (see `projects/CLAUDE.md`)
- `.claude/skills/` — agent skills
