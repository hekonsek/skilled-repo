# Terraform module for Argo CD

This module deploys Argo CD into a Kubernetes cluster using the official
`argo-cd` Helm chart. Configure the Helm provider in the calling root module;
the module does not manage cluster credentials.

## Usage

```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "argocd" {
  source = "./src/terraform"

  chart_version = "10.0.1"

  values = [yamlencode({
    server = {
      service = {
        type = "LoadBalancer"
      }
    }
  })]
}
```

The default chart version requires Kubernetes 1.25 or newer. Review the
[upstream chart upgrade notes](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)
before changing `chart_version` across a major release.

Argo CD is configured to monitor `Application` resources in every namespace.
Each `AppProject` must still explicitly allow the namespaces it serves through
its `spec.sourceNamespaces` field.

Sensitive data should be passed through `set_sensitive_values` or, preferably,
managed by an external secrets system. Terraform still stores sensitive values
in state, so ensure the state backend is appropriately protected.

## Helm provider compatibility


[Pull request #1804](https://github.com/hashicorp/terraform-provider-helm/pull/1804)
proposed preserving state when release lookup returns a transient error, but it
was closed without being merged. Do not relax the provider pin until an upstream
release contains an equivalent fix and its state migration has been tested.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Whether a failed installation is rolled back automatically. Enabling this also enables waiting. | `bool` | `true` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Name of the Argo CD Helm chart. | `string` | `"argo-cd"` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Repository containing the Argo CD Helm chart. | `string` | `"https://argoproj.github.io/argo-helm"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of the Argo CD Helm chart to install. | `string` | `"10.0.1"` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Whether resources created during a failed upgrade are removed. | `bool` | `true` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Whether Helm creates the release namespace when it does not exist. | `bool` | `true` | no |
| <a name="input_dependency_update"></a> [dependency\_update](#input\_dependency\_update) | Whether Helm updates chart dependencies before installation. | `bool` | `false` | no |
| <a name="input_lint"></a> [lint](#input\_lint) | Whether Helm lints the chart during planning. | `bool` | `false` | no |
| <a name="input_max_history"></a> [max\_history](#input\_max\_history) | Maximum number of Helm release revisions to retain. Zero retains all revisions. | `number` | `10` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace in which Argo CD is installed. | `string` | `"argocd"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Name of the Helm release. | `string` | `"argocd"` | no |
| <a name="input_set_sensitive_values"></a> [set\_sensitive\_values](#input\_set\_sensitive\_values) | Sensitive Helm values set by path. Values are redacted from CLI output but remain in Terraform state. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>    type  = optional(string, "auto")<br/>  }))</pre> | `[]` | no |
| <a name="input_set_values"></a> [set\_values](#input\_set\_values) | Helm values set by path. Use type = "string" to prevent Helm type coercion. | <pre>list(object({<br/>    name  = string<br/>    value = optional(string)<br/>    type  = optional(string, "auto")<br/>  }))</pre> | `[]` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Seconds to wait for an individual Kubernetes operation. | `number` | `600` | no |
| <a name="input_values"></a> [values](#input\_values) | List of YAML strings containing additional Helm values. Later entries take precedence. | `list(string)` | `[]` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | Whether Terraform waits for all release resources to become ready. | `bool` | `true` | no |
| <a name="input_wait_for_jobs"></a> [wait\_for\_jobs](#input\_wait\_for\_jobs) | Whether Terraform waits for release jobs to complete when wait is enabled. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chart_version"></a> [chart\_version](#output\_chart\_version) | Version of the deployed Argo CD Helm chart. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Kubernetes namespace containing Argo CD. |
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | Name of the Argo CD Helm release. |
| <a name="output_status"></a> [status](#output\_status) | Status of the Argo CD Helm release. |
<!-- END_TF_DOCS -->
