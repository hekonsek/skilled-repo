provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

module "argocd" {
  source = "../.."

  values = [yamlencode({
    server = {
      service = {
        type = "LoadBalancer"
      }
    }
  })]
}
