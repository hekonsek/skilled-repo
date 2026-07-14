mock_provider "helm" {}

run "default_configuration" {
  command = plan

  assert {
    condition     = helm_release.argocd.name == "argocd"
    error_message = "The default release name must be argocd."
  }

  assert {
    condition     = helm_release.argocd.namespace == "argocd"
    error_message = "The default namespace must be argocd."
  }

  assert {
    condition     = helm_release.argocd.version == "10.0.1"
    error_message = "The chart version must be pinned."
  }

  assert {
    condition     = helm_release.argocd.atomic && helm_release.argocd.cleanup_on_fail
    error_message = "Safe failure handling must be enabled by default."
  }
}

run "custom_configuration" {
  command = plan

  variables {
    release_name = "platform-argocd"
    namespace    = "platform"
    values = [yamlencode({
      server = {
        service = {
          type = "ClusterIP"
        }
      }
    })]
    set_values = [
      {
        name  = "global.domain"
        value = "argocd.example.com"
        type  = "string"
      }
    ]
  }

  assert {
    condition     = helm_release.argocd.name == "platform-argocd" && helm_release.argocd.namespace == "platform"
    error_message = "Custom release identity must be passed to Helm."
  }

  assert {
    condition     = helm_release.argocd.set[0].value == "argocd.example.com"
    error_message = "Custom set values must be passed to Helm."
  }
}
