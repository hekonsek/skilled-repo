# Reference Terraform modules by GitHub URL and latest Git tag in generated skills

## Context

Skills created from Terraform module repositories need to explain how agents should consume the module. Copying the module implementation into generated Terraform configuration duplicates its source, while referencing a branch such as `main` makes builds depend on mutable code. A GitHub source URL pinned to a released Git tag preserves the relationship with the original module and makes module resolution reproducible.

## Decision

When we create a skill based on a Terraform module repository, we will instruct the skill to reference the module by its GitHub URL and the latest stable Git tag available when the skill is created or updated. Generated examples will pin that tag explicitly, for example:

```hcl
module "example" {
  source = "git::https://github.com/example/terraform-example.git?ref=v1.2.3"
}
```

The skill may also tell the user that it can generate inline Terraform configuration based on the module contents when the user prefers inlining. Inlining is an explicit alternative, not the default module-consumption guidance.

## Consequences

Positive consequences:

- Generated guidance keeps the upstream module as the single source of truth.
- Pinning a released tag makes module use reproducible and protects consumers from unexpected changes to a branch.
- Users retain the option to request self-contained, inline configuration when that better fits their constraints.

Negative consequences:

- The pinned tag can become outdated and must be refreshed when the skill is maintained.
- Resolving the latest stable tag requires access to the repository and a clear release-tagging convention.
- Inline output can diverge from the upstream module and shifts maintenance responsibility to the generated configuration.

## Alternatives Considered

- **Reference the default branch:** rejected because branch contents are mutable and can change without a corresponding update to the skill.
- **Inline the module contents by default:** rejected because it duplicates implementation, obscures provenance, and prevents consumers from receiving upstream fixes through an intentional version update.
- **Use an unpinned GitHub URL:** rejected because it does not provide reproducible module resolution.
