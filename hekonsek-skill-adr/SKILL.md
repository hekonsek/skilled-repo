---
name: skill-adr
description: Creates, updates, and reviews Markdown ADR (Architecture Decision Record) documentation projects. Use when working with Architecture Decision Records or architecture documentation, ADR naming conventions, ADR document structure, or ADR validation.
---

# ADR Documentation Projects

## Overview

Use this skill to create or maintain Architecture Decision Record (ADR)
collections that are plain Markdown repositories or Markdown documentation
folders inside an existing repository.

## Workflow

1. Identify the ADR collection domain and scope.
2. Create or update the project layout.
3. Add ADR Markdown files under the project's ADR directory.
4. Name each ADR file from its sequence number, optional category, and title.
5. Write each ADR with the required Markdown sections.
6. Validate the Markdown structure and naming conventions.

## Project Layout

Use this repository structure:

```text
.
|-- README.md
|-- adr/
|   |-- 01-use-typescript-instead-of-javascript.md
|   |-- 02-use-options-object-for-optional-parameters.md
|   `-- security/
|       `-- security_01-use-execfile-instead-of-exec.md
`-- .github/
    `-- workflows/
        `-- ci.yml
```

Required:

- `README.md`: describes the ADR collection purpose and target domain.
- `adr/`: stores ADR Markdown files.

Optional:

- `adr/<category>/`: groups ADRs by category, such as `security`.
- `.github/workflows/ci.yml`: validates Markdown or repository conventions in CI
  when the project already has a validation toolchain.
- `LICENSE`: declares the repository license.

## README

The README should identify the collection and target domain in one short
introduction.

```md
# ADR (Architecture Decision Record) collection for Node CLI

This is ADR (Architecture Decision Record) collection containing Golden Path
recommendations for working with Node CLI.
```

## ADR Location

For a new ADR-only repository, place ADR files under `adr/`.

For an existing repository, first look for an established ADR location and use
it if present. Common alternatives include `docs/adr/`, `docs/architecture/adr/`,
and `architecture/decisions/`. Do not move existing ADRs unless the user asks for
a layout migration.

General ADRs are direct children:

```text
adr/01-use-typescript-instead-of-javascript.md
adr/02-use-options-object-for-optional-parameters.md
```

Category-specific ADRs live in subdirectories:

```text
adr/security/security_01-use-execfile-instead-of-exec.md
```

## ADR File Names

General ADRs use:

```text
NN-slugified-markdown-heading.md
```

Rules:

- `NN` is a zero-padded sequence number.
- Use the least sequence width that still sorts alphanumerically within the
  directory, such as `01` through `99` or `001` through `999`.
- Sequence numbers are monotonic within the directory.
- Derive the slug from the ADR `#` heading.
- Use lowercase kebab case for the slug.
- Use the `.md` extension.

The filename slug must match the heading:

```text
01-use-typescript-instead-of-javascript.md
```

```md
# Use TypeScript Instead of JavaScript
```

Category-specific ADRs may include a category prefix:

```text
category_NN-slugified-markdown-heading.md
```

Example:

```text
security_01-use-execfile-instead-of-exec.md
```

## ADR Document Format

Each ADR is one Markdown document with exactly one top-level heading and these
sections:

```md
# Use TypeScript Instead of JavaScript

## Context

Describe the situation, constraints, forces, and problem being solved.

## Decision

State the selected decision clearly.

## Consequences

Positive consequences:

- Describe a benefit of the decision.

Negative consequences:

- Describe a trade-off, cost, risk, operational burden, migration impact, or
  limitation of the decision.

## Alternatives Considered

Describe the relevant alternatives and why they were not selected.
```

## Writing Style

Write ADRs in a concise, direct, practical style.

- Explain project context before stating the decision.
- Use `We will ...` for accepted decisions.
- Document consequences as two separate lists: positive consequences and
  negative consequences.
- Actively look for negative consequences even when the decision is clearly
  beneficial. Do not leave the negative list empty or document only positive
  outcomes.
- Prefer concrete examples when the decision affects source layout, command
  usage, dependencies, or security posture.
- Keep each ADR focused on one decision.
- Avoid implementation details that do not affect the decision.

## Validation

Before finishing ADR work, validate the files directly:

- Check that each ADR file is under the selected ADR directory.
- Check that filenames sort correctly and match their `#` heading slug.
- Check that every ADR has exactly one top-level `#` heading.
- Check that every ADR includes `Context`, `Decision`, `Consequences`, and
  `Alternatives Considered` sections.
- Check that every `Consequences` section contains separate positive and
  negative consequence lists.
- Check that the negative consequences list documents at least one meaningful
  trade-off, cost, risk, operational burden, migration impact, or limitation.
- Run existing Markdown lint, link-check, formatting, or documentation CI tools
  when the repository already provides them.

## Review Checklist

Before finishing ADR project work, check that:

- `README.md` states the collection domain and purpose.
- Every ADR is under the selected ADR directory.
- ADR filenames sort correctly and match their `#` heading slug.
- Category ADRs use both a category directory and category filename prefix when
  that convention is already used.
- Every ADR has `Context`, `Decision`, `Consequences`, and
  `Alternatives Considered` sections.
- Accepted decisions use `We will ...`.
- Consequences use separate positive and negative consequence lists.
- Negative consequences include at least one meaningful trade-off, cost, risk,
  operational burden, migration impact, or limitation.
- Existing Markdown or documentation validation passes when available.
