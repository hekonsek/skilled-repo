variable "kubeconfig_path" {
  description = "Path to the Minikube kubeconfig file."
  type        = string
}

variable "kube_context" {
  description = "Minikube context to use from the kubeconfig file."
  type        = string
  default     = "minikube"
}
