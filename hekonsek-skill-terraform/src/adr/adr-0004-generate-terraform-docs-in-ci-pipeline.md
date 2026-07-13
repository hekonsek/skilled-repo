# Generate terraform-docs in CI pipeline

## Context

We decided that Terraform module documentation is generated with terraform-docs. Relying only on contributors to run terraform-docs locally can leave README files stale, especially when variables, outputs, providers, or requirements change in a pull request.

## Decision

We will generate terraform-docs in a GitHub Actions CI pipeline. The workflow should run when Terraform files change, inject generated documentation into `README.md`, and commit the updated README back to the branch. The generated section should use the markers defined in ADR 0003.

Example workflow:

```yml
name: Generate terraform-docs

on:
  push:
    paths:
      - '*.tf'
  workflow_dispatch:

permissions:
  contents: write  # needed to push the commit

jobs:
  generate-terraform-docs:
    name: "Generate terraform-docs"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - uses: terraform-docs/gh-actions@v1.4.1
        with:
          output-file: README.md
          output-method: inject
          working-dir: .

      # Needed to avoid permission errors in the next step
      - name: Fix file ownership
        run: sudo chown -R $USER:$USER .

      - name: Commit changes
        uses: stefanzweifel/git-auto-commit-action@v7.1.0
        with:
          commit_message: "docs: update terraform-docs in README"
          file_pattern: README.md
```

## Consequences

**Positive**

- Keeps user documentation current without depending on every contributor to run terraform-docs locally.
- Makes documentation updates visible as normal Git changes.
- Standardizes terraform-docs execution across repositories and contributors.

**Negative**

- Requires GitHub Actions write permissions so the workflow can commit documentation updates.
- May add follow-up commits after Terraform changes are pushed.
- Workflow failures can block documentation refresh even when Terraform code is otherwise valid.

## Alternatives considered

- **Local generation only:** rejected because it is easy to forget and creates stale README files.
- **CI validation only:** rejected because it detects drift but still leaves contributors or maintainers to perform the update manually.
