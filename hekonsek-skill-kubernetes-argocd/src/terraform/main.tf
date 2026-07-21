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

  values = var.values

  dynamic "set" {
    for_each = concat(var.set_values, [{
      name  = "configs.params.application\\.namespaces"
      value = "*"
      type  = "string"
    }])

    content {
      name  = set.value.name
      value = coalesce(set.value.value, "")
      type  = set.value.type
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive_values

    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = set_sensitive.value.type
    }
  }
}
