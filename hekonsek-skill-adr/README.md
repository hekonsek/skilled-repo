# skill-adr: Agent skill for working with a lightweight ADR documentation

An Agent Skill for creating, updating, and reviewing Markdown Architecture
Decision Record (ADR) documentation projects. This skill is intentionally dedicated for working with simplified version of ADR that we find most useful for the majority of the projects.

The skill is intentionally tool-agnostic. It follows the portable
[Agent Skills](https://skill.md/) format and does not require Codex, OpenAI or any ADR-specific generator.

## What it does

`skill-adr` gives an AI agent concise instructions for working with ADR
collections:

- choosing or preserving an ADR directory such as `adr/` or `docs/adr/`
- naming ADR files with sortable sequence numbers and heading-based slugs
- writing ADRs with `Context`, `Decision`, `Consequences`, and
  `Alternatives Considered` sections, including separate positive and negative
  consequence lists with meaningful trade-offs
- keeping ADR prose concise, practical, and decision-focused
- validating ADR Markdown structure and naming conventions

## Layout

```text
skill-adr/
|-- README.md
`-- SKILL.md
```

`SKILL.md` is the skill package. It contains the required `name` and
`description` frontmatter plus the instructions an agent should follow.

## Install

Copy or clone this directory into any Agent Skills-compatible client.

For tools that load skills from a local skills directory, keep the folder name
as `skill-adr` because the skill name in `SKILL.md` matches the parent
directory.

## Validate

Validate with the reference Agent Skills validator:

```bash
skills-ref validate /path/to/skill-adr
```

If `skills-ref` is not installed, install it from the Agent Skills reference
implementation:

```bash
python3 -m venv /tmp/skills-ref-venv
. /tmp/skills-ref-venv/bin/activate
pip install 'git+https://github.com/agentskills/agentskills.git#subdirectory=skills-ref'
skills-ref validate /path/to/skill-adr
```
