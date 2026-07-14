output "release_name" {
  description = "Name of the Argo CD Helm release."
  value       = helm_release.argocd.name
}

output "namespace" {
  description = "Kubernetes namespace containing Argo CD."
  value       = helm_release.argocd.namespace
}

output "chart_version" {
  description = "Version of the deployed Argo CD Helm chart."
  value       = helm_release.argocd.version
}

output "status" {
  description = "Status of the Argo CD Helm release."
  value       = helm_release.argocd.status
}
