output "argocd_namespace" {
  description = "Kubernetes namespace containing Argo CD."
  value       = module.argocd.namespace
}
