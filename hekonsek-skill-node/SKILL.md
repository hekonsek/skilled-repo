---
name: skill-node
description: Apply opinionated Node.js and TypeScript project conventions for API design, error handling, service-oriented hexagonal architecture, dependency installation, builds, Pino logging, and test layout. Use when creating, reviewing, refactoring, or validating Node.js applications, libraries, services, or CLI projects and their npm workflows.
---

# Node.js Project Conventions

Apply these conventions as defaults. Follow explicit user requirements and established target-repository conventions when they conflict. Keep changes within the requested scope; do not migrate an existing project solely to enforce a default without approval.

## Workflow

1. Determine whether the project is an application, library, service, CLI, or a combination.
2. Inspect the relevant source layout, `package.json`, lockfile, TypeScript configuration, tests, logging setup, and repository instructions before changing code.
3. Apply only the conventions relevant to the task. Preserve compatible local patterns.
4. Call out material conflicts between these defaults and the repository instead of silently imposing a different architecture or tool.
5. Validate with the repository's existing scripts. For npm projects, install cleanly when necessary, then run the build and relevant test, type-check, lint, or packaging commands.

## Use TypeScript by Default

- Write new Node.js application and shared application code in TypeScript.
- Compile TypeScript to JavaScript for Node.js runtime execution.
- Use explicit types and public contracts where they improve module boundaries and refactoring safety.
- Do not convert established JavaScript code to TypeScript unless the requested work includes that migration.

## Design Function Parameters for Change

Use positional arguments for required, conceptually atomic inputs. Put optional runtime configuration in one trailing options object:

```ts
interface RunCommandOptions {
  cwd?: string
  signal?: AbortSignal
  timeout?: number
  verbose?: boolean
}

function runCommand(command: string, options?: RunCommandOptions) {}
```

- Prefer named options over multiple optional positional parameters.
- Keep required business input separate from optional execution settings.
- Use a required input object when the business operation naturally has several required fields.
- Give exported option types descriptive, API-specific names.

## Let Errors Flow by Default

Do not catch an error unless the catch changes or improves the failure mode. Catch only to:

- add context the caller does not already have;
- translate an infrastructure failure at an architectural boundary;
- clean up, compensate, retry, or deliberately change control flow;
- convert failure into an explicit result; or
- perform final logging and map the failure at an entrypoint such as a CLI or HTTP adapter.

Avoid catches that merely rethrow the same error or replace it with a less informative error. Preserve the original cause when translating:

```ts
try {
  await httpClient.send(request)
} catch (error) {
  throw new NotificationDeliveryError("Failed to deliver notification", {
    cause: error,
  })
}
```

Log a failure at the layer responsible for handling or presenting it; avoid logging the same propagated error in every layer.

## Organize Around Service Hexagons

Use a service-oriented form of hexagonal architecture for projects that contain business behavior and external integrations:

```text
src/
  adapters/
    in/
      cli/
      kafka/
      rest/
  services/
    payment/
      payment.service.ts
      adapters/
        out/
      config/
```

- Organize `src/services` by business feature rather than global technical layers.
- Give each service ownership of its behavior, public contract, configuration, and infrastructure integrations.
- Treat the public service contract as the input port. Other services and library consumers must use that contract rather than service internals.
- Put transport-facing input adapters under `src/adapters/in`. Let them parse external input, supply authentication or request context, invoke services, and map results to transport responses.
- Keep transport-specific concerns out of services.
- Put output adapters for databases, external HTTP APIs, brokers, and filesystems under the service that owns the dependency, typically `src/services/<feature>/adapters/out`.
- Inject or otherwise replace external dependencies so services can be tested through their contracts.
- Prefer services as the business entrypoint; do not add separate use-case classes unless the project's complexity demonstrates a need for them.

Use a simpler structure when the project has no meaningful business or integration boundaries. Do not add architectural indirection mechanically.

## Make npm Workflows Reproducible

For npm-based projects:

- Commit `package-lock.json` and use `npm ci` for clean dependency installation in CI and clean-checkout validation.
- Use `npm install` when intentionally changing dependencies and updating the lockfile.
- Run validation after a clean install when lockfile integrity or reproducibility matters.
- Use the package manager's frozen or immutable install equivalent when the repository standardizes on pnpm, Yarn, or another tool.

Projects that require compilation, bundling, generation, or build-time preparation must expose a stable `build` script:

```json
{
  "scripts": {
    "build": "tsc"
  }
}
```

- Use `npm run build` as the npm project's build-validation entrypoint.
- Keep CI independent of the underlying build tool by calling the script instead of `tsc`, a bundler, or a generator directly.
- Keep tests, linting, formatting, packaging, and security scanning in separate scripts unless they are genuinely required to produce the build artifact.
- Do not invent a build step for a package that does not need one.

## Use Pino and Inject Loggers

Use Pino as the default logger for new Node.js projects that need application logging. Prefer structured fields over interpolated log strings, and use standard log levels consistently.

Create and configure the root logger at an application boundary such as bootstrap code, a CLI handler, an HTTP adapter, a consumer, or a scheduled job. Inject a Pino `Logger` into services and libraries:

```ts
import type { Logger } from "pino"

export class PaymentService {
  private readonly logger: Logger

  constructor(logger: Logger) {
    this.logger = logger.child({ service: "payment" })
  }
}
```

- Let entrypoints control log level, destination, formatting, and environment-specific configuration.
- Pass a child logger when adapter context such as `requestId`, `tenantId`, job name, or command name is useful.
- Let a service create a child from its injected logger for stable service-specific fields.
- Do not create a new root logger inside a reusable service or library.
- Avoid global logger singletons and direct `console` logging in application code when Pino is available.
- Inject a silent, fake, or test-configured logger in tests.

## Keep Tests Outside Production Source

- Put production code under `src` and automated tests under a top-level `test` directory.
- Mirror useful portions of the `src` tree under `test` when that improves navigation, without requiring a mechanical one-to-one mirror.
- Keep test-only fixtures, snapshots, fakes, helpers, and integration setup under `test`.
- Configure builds, bundles, and published packages so test-only files are not included accidentally.
- Preserve a stronger established local test-layout convention instead of moving tests as an unrelated change.

## Validate the Result

Choose checks supported by the target repository and proportionate to the change:

1. Restore dependencies with the repository's clean-install command when needed.
2. Run `npm run build` when the project defines a build script.
3. Run relevant tests and any existing type-check, lint, format-check, packaging, or smoke-test scripts.
4. Review public APIs for required-input versus optional-options separation.
5. Check that service code is independent of transport concerns and that external dependencies cross explicit adapter boundaries.
6. Check that errors retain their causes and are logged or translated only at responsible boundaries.
7. Check that reusable services receive configured loggers rather than constructing root loggers.
