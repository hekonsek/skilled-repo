---
name: skill-compiler
description: Compile an agent-optimized SKILL.md from source material in a src directory, including ADRs, documentation, instructions, source code, snippets, schemas, and data format descriptions. Use when asked to "compile a skill", create a skill from source content, convert human-friendly guidance into an Agent Skills SKILL.md, or distill examples and project knowledge into reusable agent instructions.
---

# Skill compiler

Compile source material into a concise, portable `SKILL.md` that follows the [Agent Skills specification](https://skill.md) and is optimized for any compatible agent to use after activation.

## Output Contract

Produce an agent-agnostic skill. Do not assume a specific agent, model, vendor, client, proprietary tool name, or vendor-specific directory layout. Use generic capability-based instructions such as "search the source files" or "run the validation command" unless the source or user explicitly requires a particular environment.

Follow the Agent Skills specification at <https://skill.md>. Treat specification compliance and cross-agent portability as required output properties, not optional style preferences. When an environment-specific dependency is essential, state it explicitly and isolate it from the portable workflow; use the specification's `compatibility` field when appropriate.

## Inputs

Use `src/` in the current skill directory as the default source directory. If the user provides another source path, use that path instead. If no source directory exists and no path is provided, ask for the source location.

Treat source material as authoritative when it includes:

- Architecture Decision Records, design notes, and technical rationale
- Human-facing instructions, runbooks, checklists, and policies
- Source code, tests, examples, snippets, and configuration
- Data format descriptions, schemas, fixtures, and API contracts
- Existing skill drafts, README files, or product documentation

Ignore generated dependencies, build outputs, lockfile noise, vendored code, caches, binary blobs, and unrelated project metadata unless the source material explicitly depends on them.

## Workflow

1. Inventory the source directory before writing. Identify file types, likely primary documents, code examples, and repeated themes.
2. Read the most relevant source files first. For large sources, search for headings, decision statements, examples, constraints, "must", "should", "when", "avoid", "workflow", and "validation".
3. Extract the skill's intended capability, activation contexts, required workflow, constraints, validation steps, and reusable patterns.
4. Distill human-friendly prose into direct agent instructions. Preserve operational rules and domain-specific details; remove background narrative, duplicated rationale, and generic advice an agent already knows.
5. Infer a skill name only when the source clearly supports it. Otherwise use the current directory name. Normalize the frontmatter `name` to lowercase letters, digits, and hyphens.
6. Write or update `SKILL.md` at the skill root unless the user requests a different output path.
7. Validate the compiled file against the current Agent Skills specification at <https://skill.md> and reread it for usefulness as standalone, agent-agnostic instructions.

## Compilation Rules

Produce a `SKILL.md` with YAML frontmatter followed by Markdown instructions.

Frontmatter requirements:

- Include `name`.
- Include `description`.
- Keep `name` 1-64 characters, using only lowercase letters, digits, and single hyphens. Do not start or end it with a hyphen, use consecutive hyphens, or let it differ from the parent directory name.
- Keep `description` non-empty and under 1024 characters.
- Make `description` describe both what the skill does and when to use it, because agents use it for activation.
- Include important trigger phrases from the source or user request, especially exact user-facing phrases such as "compile a skill" when relevant.
- Include only fields permitted by the Agent Skills specification. Avoid product-specific metadata unless the user or source explicitly requires it and the specification can represent it portably.

Body requirements:

- Use imperative instructions an agent can execute.
- Address the executing system generically as "the agent" when a subject is necessary. Do not name or assume Codex, Claude, ChatGPT, or another agent implementation.
- Describe required capabilities and outcomes instead of assuming vendor-specific tools, commands, approval flows, memory systems, or orchestration features.
- Keep the body concise and agent-oriented, ideally under 500 lines.
- Put essential workflow and decision rules in `SKILL.md`; move only large optional detail to referenced files when the task calls for a multi-file skill.
- Use relative paths for any referenced skill resources.
- Prefer concrete checklists, commands, patterns, and examples over broad explanations.
- State assumptions, inputs, outputs, edge cases, and validation steps when they affect execution.
- Do not include a "when to use this skill" section in the body; activation guidance belongs in the `description`.
- Do not include source commentary, authorship notes, migration logs, or explanations of how compilation was performed.

## Source Interpretation

When sources conflict, prefer in this order:

1. Explicit user instructions for the current compilation task
2. Existing `SKILL.md` or skill-specific source documents
3. ADRs and decision records
4. Tests, examples, schemas, and executable behavior
5. README files and general documentation
6. Inferred conventions from code structure

If a conflict materially changes the compiled skill, either encode the higher-priority rule or ask the user to resolve it. Do not silently merge incompatible instructions.

When source code is the main input, derive instructions from observable behavior, public APIs, tests, CLI commands, configuration, and error handling. Avoid documenting private implementation details unless agents need them to perform the skill.

When ADRs are the main input, preserve accepted decisions, constraints, consequences, and rejected alternatives only when they guide future agent behavior.

When schemas or data formats are the main input, include field semantics, required/optional rules, validation behavior, examples, and compatibility constraints that agents need to produce or edit valid data.

## Output Quality

The compiled skill should be:

- Portable across skill-compatible agents
- Free of accidental vendor, model, client, and tool-runtime coupling
- Self-contained enough to be useful after activation
- Specific enough to change agent behavior
- Short enough to avoid wasting context
- Grounded in the source material rather than generic best practices
- Clear about required files, commands, validation, and expected outputs

Before finishing, check that:

- `SKILL.md` exists at the intended output path.
- Frontmatter is valid YAML bounded by `---`.
- `name`, `description`, optional fields, directory naming, and bundled-resource references comply with <https://skill.md>.
- The description contains the main activation triggers.
- The body tells an agent what to do, not a human what the source project is.
- The instructions remain usable by different Agent Skills-compatible implementations without vendor-specific assumptions.
- No important source constraints were lost.
- No unsupported or source-invented requirements were added.
