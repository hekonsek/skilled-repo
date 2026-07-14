variable "kubeconfig_path" {
  description = "Path to the kubeconfig used to install Argo CD."
  type        = string
  default     = "~/.kube/config"
}
