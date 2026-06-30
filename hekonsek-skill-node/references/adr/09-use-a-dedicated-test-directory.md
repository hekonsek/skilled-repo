# Use a Dedicated Test Directory

## Context

We are building Node.js applications, libraries, and CLI tooling where tests need
to stay easy to discover, run, and maintain.

Tests often need supporting files such as fixtures, snapshots, fake adapters,
test data, or integration setup. When test files are colocated with source files
under `src`, production code and test-only code become mixed in the same
directory tree. This can make package publishing, build output, and source
navigation less predictable.

We want a default test layout that:

- keeps production source files focused on runtime code
- makes the complete test suite easy to find
- gives test-only fixtures and helpers a clear home
- avoids accidentally including test files in runtime bundles or published
  source artifacts
- works consistently across applications, libraries, and CLI projects

## Decision

We will place automated tests in a dedicated top-level `test` directory instead
of colocating test files with source files.

Production code belongs under `src`. Test code belongs under `test`.

Example structure:

```text
src/
  services/
    payment/
      payment.service.ts
  adapters/
    in/
      cli/
        cli.ts
test/
  services/
    payment/
      payment.service.test.ts
  adapters/
    in/
      cli/
        cli.test.ts
  fixtures/
    payment-fixtures.ts
```

The `test` directory may mirror the relevant parts of the `src` structure when
that makes tests easier to navigate, but it does not need to mirror every source
directory mechanically.

Test-only helpers, fixtures, snapshots, fake implementations, and integration
setup should also live under `test` unless the project has a stronger local
convention for shared development tooling.

## Consequences

Positive:

- Production source directories stay focused on runtime code
- The test suite has one predictable location for developers and automation
- Test fixtures and helpers have a clear place outside `src`
- Build, bundle, and publish configuration can exclude tests more easily
- Source navigation is less noisy in projects with many test files

Negative:

- Developers need to switch between `src` and `test` when editing code and its
  tests together
- The relationship between a source file and its test may be less obvious than
  with colocated `*.test.ts` files
- Renaming or moving source files can require a separate test tree update
- Very small projects may find a separate test directory more structure than
  they need

## Alternatives Considered

- **Colocate tests next to source files**. This keeps each test close to the
  code it exercises, but it mixes runtime and test-only files in the same tree
  and makes publishing or bundling boundaries less explicit.

- **Use multiple top-level test directories by test type**. Directories such as
  `unit`, `integration`, and `e2e` can be useful in larger systems, but they make
  the default layout more complex. We prefer one `test` directory that can
  contain type-specific subdirectories when a project needs them.

- **Put tests under `src/test`**. This keeps tests inside the source tree, but it
  weakens the separation between production code and test-only code.
