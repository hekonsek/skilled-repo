provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.kube_context
  }
}

module "argocd" {
  source = "../../.."

  release_name = "argocd-e2e"
  namespace    = "argocd-e2e"
  timeout      = 900

  values = [yamlencode({
    applicationSet = {
      enabled = false
    }
    dex = {
      enabled = false
    }
    notifications = {
      enabled = false
    }
    server = {
      service = {
        type = "ClusterIP"
      }
    }
  })]
}
