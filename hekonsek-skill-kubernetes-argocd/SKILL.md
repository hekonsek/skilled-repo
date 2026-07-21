---
name: skill-kubernetes-argocd
description: Deploy and maintain environment-isolated Argo CD instances on Kubernetes by consuming the upstream Terraform module at a stable pinned tag. Use when designing Argo CD platform topology, adding the module to Terraform root modules, configuring Helm values and namespaced Applications, reviewing upgrades or state safety, or maintaining the module and its generated documentation.
---

# Kubernetes Argo CD

## Establish the platform boundary

- Deploy one independent Argo CD instance in each platform deployment, such as development, staging, and production.
- Let each instance reconcile only its own environment's applications and platform configuration. Do not give it credentials for other platform deployments.
- Treat the platform deployment as the ownership and failure boundary. Use `AppProject` policies, repositories, and permissions for application isolation instead of deploying one Argo CD instance per application.
- Promote Argo CD versions and configuration through environments in the same sequence as other platform changes.
- Bootstrap or restore the environment's Argo CD instance before allowing it to reconcile the remaining platform and application resources.
- Preserve independent operation and recovery. Add aggregated observability for cross-environment views without centralizing reconciliation.

## Consume the released Terraform module

Use the upstream module through its GitHub HTTPS URL and pin the source to the latest stable Git tag. The stable tag verified when this skill was compiled is `v0.1.0`:

```hcl
module "argocd" {
  source = "git::https://github.com/hekonsek/skill-kubernetes-argocd.git//src/terraform?ref=v0.1.0"

  values = [yamlencode({
    server = {
      service = {
        type = "LoadBalancer"
      }
    }
  })]
}
```

- Configure the Helm provider and Kubernetes credentials in the calling root module. Do not manage cluster credentials inside the reusable module.
- Keep the source pinned to an immutable stable tag. Do not use `main`, another mutable branch, or an unpinned source.
- Preserve the `//src/terraform` module subdirectory in the Git source URL.
- Resolve the repository's newest stable tag whenever maintaining or recompiling this skill, and update the example if a newer release exists.
- Do not copy the module's resources into a root module by default. Offer inline Terraform only when the user explicitly requests a self-contained configuration, and warn that the copied implementation can diverge from upstream.

## Respect release boundaries

- Inspect the selected tag rather than assuming that default-branch behavior has been released.
- `v0.1.0` requires Terraform `>= 1.5.0` and `hashicorp/helm >= 3.0.0, < 4.0.0`. Honor those constraints when consuming that tag.
- The default branch currently contains unreleased changes that pin `hashicorp/helm` to `2.17.0` and configure Argo CD to watch `Application` resources in all namespaces. Do not attribute those behaviors to `v0.1.0`.
- When a task requires unreleased behavior, prefer waiting for or creating a stable module release. Use an immutable commit only when the user explicitly accepts bypassing the stable-release convention.
- Before adopting a new tag, review the module diff, Argo CD chart upgrade notes, Kubernetes compatibility, provider constraints, state migration behavior, and release tests.

## Configure the module

- Default the release name and namespace to `argocd` unless the platform provides environment-specific names.
- Pin the Argo CD chart version. The module defaults to chart `10.0.1`, which requires Kubernetes 1.25 or newer.
- Keep failure-safe defaults enabled: atomic installation, cleanup on failed upgrades, readiness waiting, and job waiting.
- Pass structured Helm configuration through `values` as YAML strings; later list entries take precedence.
- Use `set_values` for non-sensitive path overrides. Set `type = "string"` when Helm coercion would change the intended value.
- Prefer an external secrets system for credentials. If Terraform must pass a secret Helm value, use `set_sensitive_values` so CLI output is redacted.
- Warn that sensitive values remain in Terraform state. Protect shared root modules with an encrypted, lock-capable remote backend and supply sensitive backend parameters through environment configuration or CI variables.
- Use the module outputs for release name, namespace, chart version, and release status rather than duplicating those values.

## Support namespaced Applications

For releases that do not configure namespaced `Application` watching internally, pass the setting explicitly:

```hcl
set_values = [{
  name  = "configs.params.application\\.namespaces"
  value = "*"
  type  = "string"
}]
```

- Require every `AppProject` to authorize the namespaces it serves through `spec.sourceNamespaces`. Watching every namespace does not grant project-level permission.
- Keep each Argo CD instance scoped to its platform environment even when it watches multiple namespaces within that environment.
- Remove an explicit override only after verifying that the selected stable module release supplies the same setting internally.

## Maintain the upstream module

- Preserve the conventional module layout: resources in `main.tf`, inputs in `variables.tf`, outputs in `outputs.tf`, provider constraints in `versions.tf`, examples under `examples/`, and tests under `tests/`.
- Keep provider configuration in the calling root module unless the reusable module requires an exceptional alias declaration.
- Validate input types and constraints, retain secure failure defaults, and expose only useful caller-facing outputs.
- Treat README content between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` as generated. Change Terraform declarations or terraform-docs configuration and regenerate the block; never edit the generated tables manually.
- Preserve human-written usage, compatibility, upgrade, and secret-handling guidance outside the generated markers.
- Keep example Terraform and provider constraints aligned with the module.
- Treat Helm provider nested `set` blocks as unordered sets in tests. Select matching elements with a filtered expression rather than a numeric index:

```hcl
one([
  for item in helm_release.argocd.set : item
  if item.name == "global.domain"
]).value
```

## Validate Terraform changes

After changing Terraform files, run from the repository root:

```bash
terraform fmt -recursive
```

Review the formatting diff and revert unrelated formatting changes. Then run from each affected independently initialized Terraform project root:

```bash
terraform init
terraform validate
terraform test
```

Also run the repository's existing linters and CI checks. Confirm that generated documentation was regenerated rather than hand-edited and that shared root modules still use encrypted, lock-capable remote state. Report any check blocked by missing commands, credentials, backend access, provider initialization, or cluster access.
