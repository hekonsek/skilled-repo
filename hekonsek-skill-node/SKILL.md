---
name: skill-node
description: Apply Node.js project conventions captured as Architecture Decision Records. Use when creating, reviewing, refactoring, or validating Node.js, TypeScript, npm, CLI, service, library, logging, error-handling, or project-architecture work.
---

# Node Project Guidance

Use this skill when working with Node.js projects. The project conventions are
defined by the ADRs in `references/adr/`; treat them as the source of truth for
default decisions unless the user or the target repository explicitly chooses a
different convention.

## Workflow

1. Identify which part of the Node project is being changed or reviewed.
2. Read the relevant ADR files before making recommendations or edits.
3. Apply the ADR decision as the default project convention.
4. Preserve existing project behavior and local conventions when they clearly
   conflict with an ADR; call out the conflict instead of silently rewriting the
   project around the ADR.
5. Validate changes with the project's existing npm scripts when available.

## ADR Reference Map

Read these ADRs on demand:

- [Use TypeScript Instead of JavaScript](references/adr/01-use-typescript-instead-of-javascript.md):
  default language choice for Node application code.
- [Prefer using Options Object for Optional Parameters](references/adr/02-use-options-object-for-optional-parameters.md):
  API shape for optional configuration and evolving function signatures.
- [Let Errors Flow Unless Catching Adds Value](references/adr/03-let-errors-flow-unless-catching-adds-value.md):
  error propagation, wrapping, cleanup, and boundary translation.
- [Use Service-Oriented Hexagonal Architecture](references/adr/04-use-service-oriented-hexagonal-architecture.md):
  project structure, input adapters, output adapters, and service boundaries.
- [Use `npm ci` for clean dependency installation](references/adr/05-use-npm-ci-for-clean-dependency-installation.md):
  clean dependency installation and lockfile validation.
- [Use `npm run build` for build validation](references/adr/06-use-npm-run-build-for-build-validation.md):
  build validation conventions for npm-based projects.
- [Use Pino as the Default Logger](references/adr/07-use-pino-as-the-default-logger.md):
  default logging library and structured logging expectations.
- [Inject Pino Loggers Into Services and Libraries](references/adr/08-inject-pino-loggers-into-services-and-libraries.md):
  logger injection, child loggers, and service/library logging boundaries.
- [Use a Dedicated Test Directory](references/adr/09-use-a-dedicated-test-directory.md):
  test directory layout, source/test separation, and test-only fixtures.

## Working Rules

- Prefer TypeScript for new Node application code.
- Use positional arguments for required atomic inputs and a trailing options
  object for optional configuration.
- Let errors propagate unless catching adds context, performs cleanup, maps a
  boundary result, or otherwise improves the failure mode.
- Keep business services independent from transports and infrastructure.
- Use `npm ci` for clean dependency installation when an npm lockfile exists.
- Use `npm run build` as the default build validation command when the project
  defines or needs a build step.
- Prefer Pino for logging, with logger configuration owned by application
  boundaries and logger instances injected into services and libraries.
- Keep automated tests and test-only support files under a top-level `test`
  directory instead of colocating them with source files.
