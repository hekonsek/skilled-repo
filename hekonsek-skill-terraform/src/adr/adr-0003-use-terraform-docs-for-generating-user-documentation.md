# Use terraform-docs for generating user documentation

## Context

Terraform modules need user-facing documentation that describes inputs, outputs, providers, requirements, and examples. Maintaining this documentation manually is error-prone because it can drift from the Terraform source files as variables, outputs, and provider constraints change.

## Decision

We will use [terraform-docs](https://github.com/terraform-docs/terraform-docs) to generate user documentation for Terraform modules. Module README files should include generated documentation between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` markers so contributors and CI pipelines can update documentation consistently from the Terraform configuration.

## Consequences

**Positive**

- Keeps module documentation aligned with Terraform variables, outputs, requirements, and providers.
- Reduces manual documentation work and review effort.
- Gives users a predictable README structure across modules.

**Negative**

- Requires terraform-docs to be available in local workflows or CI pipelines.
- Generated sections may be less flexible than hand-written documentation.

## Alternatives considered

- **Manual README maintenance:** rejected because documentation can easily drift from the Terraform source.
- **Custom documentation scripts:** rejected because terraform-docs already provides the required Terraform-specific metadata extraction and formatting.
- **AI-generated documentation:** considered, but rejected for generated reference documentation because terraform-docs is cheaper, more predictable, and derives content directly from Terraform source files.
