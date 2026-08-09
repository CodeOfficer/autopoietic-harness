---
name: skill-authoring
description: How to author a new agent skill for this repository — use when asked to create, extend, or review a skill under .claude/skills/.
---

# Authoring a Skill

## Purpose

Create small, self-contained skills in `.claude/skills/<skill-name>/SKILL.md` that teach an agent one repeatable workflow.

## Inputs

- The workflow to capture: its trigger, steps, and expected result.
- Relevant repository rules: the nearest `CLAUDE.md` and `kb/` (see `kb/layered-knowledge.md`).

## Steps

1. Confirm the workflow is not already covered by an existing skill; extend rather than duplicate.
2. Pick a kebab-case name that states the action (verb-noun, e.g. `governance-convention`).
3. Write `SKILL.md` with frontmatter (`name`, `description` — the description says *when* to use it) and these sections: Purpose, Inputs, Steps, Outputs, Constraints.
4. Keep steps imperative and concrete; reference kb concepts by path instead of restating them.
5. If a convention arises that existing files don't clearly imply, ask the repository owner before adopting it.

## Outputs

- One new directory `.claude/skills/<skill-name>/` containing a single short `SKILL.md`.

## Constraints

- One skill = one workflow. If a skill needs two purposes, write two skills.
- Keep it short; move durable knowledge into the appropriate layered `kb/`, not into the skill.
- No side effects beyond creating the skill files.
