# Basic Argo CD example

This example configures the Helm provider from a local kubeconfig and deploys
the Argo CD module with a `LoadBalancer` service.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 3.0.0, < 4.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_argocd"></a> [argocd](#module\_argocd) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to the kubeconfig used to install Argo CD. | `string` | `"~/.kube/config"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_argocd_namespace"></a> [argocd\_namespace](#output\_argocd\_namespace) | Kubernetes namespace containing Argo CD. |
<!-- END_TF_DOCS -->
