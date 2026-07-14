resource "helm_release" "argocd" {
  name       = var.release_name
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version
  namespace  = var.namespace

  create_namespace  = var.create_namespace
  atomic            = var.atomic
  cleanup_on_fail   = var.cleanup_on_fail
  dependency_update = var.dependency_update
  lint              = var.lint
  max_history       = var.max_history
  timeout           = var.timeout
  wait              = var.wait
  wait_for_jobs     = var.wait_for_jobs

  values        = var.values
  set           = var.set_values
  set_sensitive = var.set_sensitive_values
}
