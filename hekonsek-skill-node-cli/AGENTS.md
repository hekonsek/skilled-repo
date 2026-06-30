# skill-node-cli

This repository is an agent-agnostic skill project for opinionated Node.js CLI project structure and implementation guidance. It follows the `AGENTS.md` convention from http://agents.md/ for repository-level agent instructions.

## Project Layout

- `SKILL.md`: portable skill instructions for Codex, Claude, and other agents that support skill-style Markdown instructions.
- `references/adr/**/*.md`: imported ADRs from `../adr-node-cli/spex/adr/`. These ADRs are the source of truth for the skill guidance and should remain unchanged unless the user explicitly requests an ADR update.
- `LICENSE`: license notice copied from the source ADR project.

## Commands

- Validate skill metadata:

  ```sh
  python3 /home/hekonsek/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
  ```

- Verify imported ADR files still match the source repository:

  ```sh
  find references/adr -type f -name '*.md' -print | while read -r file; do cmp -s "$file" "../adr-node-cli/spex/adr/${file#references/adr/}" || exit 1; done
  ```

## Working Rules

- Keep the project agent-neutral. Do not add product-specific files such as `CLAUDE.md`, `.cursorrules`, or `agents/openai.yaml` unless the user asks.
- Do not edit imported ADR contents during ordinary skill maintenance. Update `SKILL.md` to refer to ADRs, not to duplicate their full content.
- Keep the skill concise. Add only files that directly support the skill.
- Prefer ASCII text unless an imported ADR already contains non-ASCII characters.
