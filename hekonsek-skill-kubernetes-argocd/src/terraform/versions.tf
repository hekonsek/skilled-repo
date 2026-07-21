terraform {
  required_version = ">= 1.5.0"

  required_providers {
    helm = {
      source = "hashicorp/helm"
      # Provider v3 can remove live releases from state after transient read errors.
      # Keep this pin until https://github.com/hashicorp/terraform-provider-helm/issues/1669 is fixed.
      version = "= 2.17.0"
    }
  }
}
