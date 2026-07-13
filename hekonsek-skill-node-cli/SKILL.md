---
name: skill-node-cli
description: |
  Opinionated guidance for creating, reviewing, and refactoring Node.js and TypeScript command-line interface projects.
  
  Use this skill when working with: 
    - Working on Node CLI project structure.
    - Working with CLI UI components like spinners, progress bars, and colorized output. 
    - Working with commander-based command definitions.
    - CLI event listeners.
    - Diagnostic logging flags.
  
  This project focuses on CLI-specific aspects of Node.js. For generic Node guidance use skill-node.
---

# Node CLI

Use this skill to apply a consistent Node.js CLI project structure and implementation style. The source of truth is the imported ADR set in `references/adr/`; read the relevant ADRs before making architectural or dependency decisions.

## Workflow

1. Identify whether the task is bootstrap, implementation, refactoring, or review.
2. Read the ADRs that match the decision area.
3. Apply the ADR decisions as the default architecture unless the target repository has a stronger local convention.
4. Keep CLI concerns in the CLI adapter layer and core/domain behavior in reusable services.
5. Preserve machine-readable output, non-TTY behavior, and testability when adding user-facing CLI output.

For broad project generation or review, read all ADRs first.

## ADR Map

- `references/adr/1-use-commander-as-library-for-node-based-command-line-tools.md`: choose Commander as the default Node CLI library.
- `references/adr/2-separate-command-line-logic-from-core-domain-business-logic.md`: separate CLI parsing and wiring from services and domain logic.
- `references/adr/3-cli-should-listen-to-events-from-core-logic-via-listeners.md`: use listener ports for core-to-CLI progress, messages, and warnings when a simple return value is not enough.
- `references/adr/4-use-chalk-for-coloring-output.md`: use Chalk for terminal color in the presentation layer only.
- `references/adr/5-use-ora-as-progress-indicator.md`: use Ora for interactive progress indication with CI, non-TTY, JSON, and quiet-mode fallbacks. Read this for any CLI command that clones or downloads GitHub repositories, fetches remote resources, performs multi-file I/O, runs installs/builds, invokes long-running subprocesses, or otherwise may leave the user waiting.
- `references/adr/6-bootstrap-new-cli-with-a-single-version-command.md`: bootstrap new CLIs with only a `version` command until real use cases exist.
- `references/adr/7-use-global-logger-flag-to-configure-logging-level.md`: expose a global `--logger` flag with `silent` as the default diagnostic logging level.
- `references/adr/security/security_1-use-execfile-instead-of-exec-and-shell-enabled-spawn-to-prevent-shell-injection.md`: use `execFile` by default and avoid shell-enabled command execution for untrusted input.

## Default Structure

When creating or reorganizing a Node CLI project, prefer:

```text
src/
|-- adapters/
|   `-- in/
|       `-- cli/
|           `-- cli.ts
|-- services/
`-- index.ts
```

Keep Commander, Chalk, Ora, stdout/stderr handling, TTY checks, JSON/quiet behavior, and process exit decisions inside the CLI adapter. Keep business services free from CLI framework imports, ANSI formatting, spinner calls, and direct console output.

## Implementation Rules

- Start a new CLI with a single `version` command that reads the package version.
- Put diagnostic logging behind a global `--logger <level>` option and default it to `silent`.
- Write structured command results to stdout when appropriate and diagnostic logs to stderr.
- Use typed return values, typed errors, or listener interfaces to communicate from services to the CLI.
- Use Chalk and Ora only in CLI/presentation modules, and always provide readable fallback behavior when color or spinners are unavailable.
- Use `child_process.execFile()` by default for invoking external programs, and avoid `exec()` or shell-enabled `spawn()` unless an exception is explicitly approved and documented.
- Add tests around services without requiring `process.argv`, Commander, TTY behavior, or console output.
