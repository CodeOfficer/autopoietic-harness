# Projects

Each subdirectory here is one project. This file supplements the root `CLAUDE.md`; root rules apply unless a rule here, or in a project's own `CLAUDE.md`, overrides them for its subtree.

## Inheritance

- **Rules:** a project follows its own `CLAUDE.md` if present, then this file, then the root `CLAUDE.md` — nearest wins on conflict.
- **Knowledge:** a project's local `kb/` supplements the repository-wide `kb/`, and takes precedence when they conflict on project-relevant topics (see `kb/layered-knowledge.md` at the root).
- The governance constitution in `kb/governance/` applies to every project.

## Project shape

Projects are spec-driven: each starts from a `spec.md` and keeps project-specific knowledge in its local `kb/`. To start a new project, copy `sample-project/`.
