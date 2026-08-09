---
id: kb-okf-format
title: Open Knowledge Format
description: The OKF conventions every kb/ directory in this repository follows
tags: [knowledge, conventions]
status: adopted
updated: 2026-08-08
owner: codeofficer
related: [kb-layered-knowledge]
---

# Open Knowledge Format

Every knowledge base in this repository is a `kb/` directory of Markdown files following the Open Knowledge Format (OKF):

- **One concept per file.** Each file explains exactly one idea, rule, or decision.
- **YAML frontmatter** on every file, with this schema:
  - `id` — stable kebab-case identifier, unique across the repo (prefix with the kb's scope, e.g. `kb-` or `kb-gov-`)
  - `title` — human-readable name
  - `description` — one line, used for discovery
  - `tags` — list of lowercase topic tags
  - `status` — `draft` | `proposed` | `adopted` | `deprecated`
  - `updated` — last-modified date (YYYY-MM-DD)
  - `owner` — accountable person
  - `related` — list of related concept `id`s
- **`index.md` for discovery.** Each `kb/` has an `index.md` listing its concepts and any sub-bases, with one-line hooks.

Keep concept files short. If a file covers two ideas, split it.
