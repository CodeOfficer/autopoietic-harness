---
id: kb-layered-knowledge
title: Layered Knowledge
description: How local kb/ directories supplement and override broader ones
tags: [knowledge, governance, conventions]
status: adopted
updated: 2026-08-08
owner: codeofficer
related: [kb-okf-format]
---

# Layered Knowledge

Knowledge is layered by directory depth, mirroring the `CLAUDE.md` rule:

1. When working in a directory, consult the nearest `kb/` first — its own, or the closest one in an ancestor directory.
2. A more-local `kb/` **supplements** broader knowledge: anything not covered locally falls through to the ancestor `kb/`.
3. When local and broader knowledge conflict on a topic relevant to the local scope, the **more-local `kb/` takes precedence**.
4. Discovery always starts at the nearest `kb/index.md`, then walks up to ancestor indexes.

Local knowledge bases should stay small: record only what differs from or extends the broader layers.
