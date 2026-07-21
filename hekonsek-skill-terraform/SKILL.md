---
name: skill-terraform
description: Apply opinionated Terraform conventions for module and environment layout, remote state, generated terraform-docs documentation, formatting, validation, IaC security tooling, and skills derived from Terraform module repositories. Use when creating, reviewing, refactoring, or validating Terraform modules, root modules, `*.tf` files, `*.tfvars` files, Terraform CI workflows, or Terraform module skills.
---

# Terraform projects

## Workflow

1. Inspect the repository before changing it. Preserve an established Terraform layout unless the task explicitly requires a migration.
2. Determine whether the change affects a reusable module, a root module, an environment composition, generated documentation, CI, or state configuration.
3. Apply the relevant structure and state rules below. When producing a skill from a Terraform module repository, also apply the module-reference rules.
4. Keep terraform-docs output generated; change its Terraform inputs or automation rather than its injected Markdown.
5. After changing any `*.tf` or `*.tfvars` file, run the formatting and validation checks from the applicable project root.

## Structure Terraform code

For a reusable module, use these conventional files when their concern exists:

- `main.tf`: resources and data sources that implement the module.
- `variables.tf`: typed inputs with descriptions and appropriate defaults.
- `outputs.tf`: values exposed to callers.
- `versions.tf`: `terraform` block, Terraform version constraint, and provider constraints.
- `providers.tf`: exceptional module-level provider requirements, such as aliases; normally configure providers in the root module.
- `locals.tf`: intermediate or computed values.
- `data.tf`: data sources separated when that improves clarity.
- `README.md`: module usage and generated reference documentation.
- `examples/`: runnable examples for reusable or published modules.
- `tests/`: automated tests, fixtures, helpers, and configuration; use integration tests such as Terratest when real infrastructure behavior must be verified.

For a root module, use `main.tf`, `providers.tf`, `versions.tf`, `variables.tf`, and `outputs.tf` for their corresponding concerns. Put environment values in `terraform.tfvars` or `*.auto.tfvars`, taking care not to commit secrets.

When introducing a new multi-environment Terraform area, separate reusable implementation from deployable compositions:

```text
environments/
  dev/
  staging/
  prod/
modules/
```

- Under each environment, group compositions by cloud and service, and optionally by region for regional providers such as AWS.
- Under `modules/`, group reusable modules by cloud and capability.
- In a repository whose primary purpose is not Terraform, nest both directories under `iac/` instead of adding them at the repository root.
- Keep all service-specific infrastructure in the same repository so cross-environment changes remain discoverable and atomic.
- Promote module changes deterministically: tag modules with semantic versions and pin environment module sources with `?ref=<tag>`.

## Produce skills from Terraform modules

When creating or updating a skill based on a Terraform module repository:

1. Identify the module repository's GitHub HTTPS URL and latest stable Git tag according to its release convention.
2. Instruct consumers to call the upstream module by that URL, pinned to the resolved tag. Do not default to copying the module implementation, an unpinned source, or a mutable branch such as `main`.
3. Generate examples in this form, preserving any module subdirectory in the source URL when applicable:

   ```hcl
   module "example" {
     source = "git::https://github.com/example/terraform-example.git?ref=v1.2.3"
   }
   ```

4. Offer inline Terraform derived from the module contents only when the user explicitly prefers a self-contained configuration. Make clear that inline code can diverge from upstream and becomes the consumer's maintenance responsibility.
5. Refresh the pinned tag whenever maintaining or recompiling the derived skill.

## Manage state safely

- Configure every shared root module with a remote backend.
- Require encryption and state locking, using either a managed backend with built-in locking or object storage with an appropriate lock service.
- Keep backend configuration with the root module, but supply sensitive or environment-specific backend parameters through environment configuration or CI variables.
- Do not use local state for shared dev, staging, or production environments, or for infrastructure managed by more than one person or pipeline.
- When changing a backend, reinitialize Terraform and plan the state migration explicitly.

## Generate module documentation

- Use `terraform-docs` to document module requirements, providers, inputs, and outputs.
- Put generated content in `README.md` between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->`.
- Treat everything inside those markers as generated output. Never manually edit, reformat, or refactor it.
- To change generated reference content, update the underlying Terraform declarations or terraform-docs configuration and let automation regenerate it.
- Preserve human-written usage guidance and examples outside the markers.

For repositories using GitHub Actions, maintain a workflow that:

- runs when Terraform files change and can also be started manually;
- invokes the terraform-docs action with README injection enabled for each applicable module;
- has the minimum `contents: write` permission needed to commit refreshed README files;
- commits only the generated documentation with a clear documentation commit message.

Prefer CI generation over requiring contributors to generate documentation locally. Do not replace `terraform-docs` with hand-maintained or AI-generated reference tables.

## Select security tooling

- Do not introduce, extend, or recommend Terrascan for Terraform scanning.
- When an existing pipeline uses Terrascan, migrate it to an actively maintained IaC scanner instead of forking or self-maintaining Terrascan.
- Select the replacement based on current project and organizational requirements; do not claim the source ADRs prescribe a particular replacement.

## Validate changes

After changing `*.tf` or `*.tfvars` files:

1. From the repository root, run:

   ```sh
   terraform fmt -recursive
   ```

2. From each affected independently initialized Terraform project root, initialize if necessary and validate:

   ```sh
   terraform init
   terraform validate
   ```

3. Review the formatting diff so unrelated files were not changed unintentionally.
4. Run the repository's existing Terraform tests, linters, and CI checks when available.
5. Confirm shared root modules still use encrypted, lock-capable remote state and that generated documentation blocks were not manually edited.

Report any check that cannot run, including the missing command, credentials, backend access, or provider initialization that blocked it.
