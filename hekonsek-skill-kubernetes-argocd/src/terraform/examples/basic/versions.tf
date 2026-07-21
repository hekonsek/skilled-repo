terraform {
  required_version = ">= 1.5.0"

  required_providers {
    helm = {
      source = "hashicorp/helm"
      #       This module intentionally pins the HashiCorp Helm provider to `2.17.0`. Provider v3 can intermittently remove an existing `helm_release` from Terraform
      # state when a release lookup fails, causing the next apply to attempt a duplicate
      # installation and fail because the Helm release name is still in use. This is
      # tracked in [hashicorp/terraform-provider-helm#1669](https://github.com/hashicorp/terraform-provider-helm/issues/1669).
      version = "= 2.17.0"
    }
  }
}
