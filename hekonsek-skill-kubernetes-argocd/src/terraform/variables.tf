variable "release_name" {
  description = "Name of the Helm release."
  type        = string
  default     = "argocd"

  validation {
    condition     = length(var.release_name) <= 53 && can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.release_name))
    error_message = "release_name must be a valid lowercase DNS label no longer than 53 characters."
  }
}

variable "namespace" {
  description = "Kubernetes namespace in which Argo CD is installed."
  type        = string
  default     = "argocd"

  validation {
    condition     = length(var.namespace) <= 63 && can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.namespace))
    error_message = "namespace must be a valid lowercase DNS label no longer than 63 characters."
  }
}

variable "create_namespace" {
  description = "Whether Helm creates the release namespace when it does not exist."
  type        = bool
  default     = true
}

variable "chart_repository" {
  description = "Repository containing the Argo CD Helm chart."
  type        = string
  default     = "https://argoproj.github.io/argo-helm"

  validation {
    condition     = length(trimspace(var.chart_repository)) > 0
    error_message = "chart_repository must not be empty."
  }
}

variable "chart_name" {
  description = "Name of the Argo CD Helm chart."
  type        = string
  default     = "argo-cd"

  validation {
    condition     = length(trimspace(var.chart_name)) > 0
    error_message = "chart_name must not be empty."
  }
}

variable "chart_version" {
  description = "Version of the Argo CD Helm chart to install."
  type        = string
  default     = "10.0.1"

  validation {
    condition     = length(trimspace(var.chart_version)) > 0
    error_message = "chart_version must not be empty."
  }
}

variable "values" {
  description = "List of YAML strings containing additional Helm values. Later entries take precedence."
  type        = list(string)
  default     = []
}

variable "set_values" {
  description = "Helm values set by path. Use type = \"string\" to prevent Helm type coercion."
  type = list(object({
    name  = string
    value = optional(string)
    type  = optional(string, "auto")
  }))
  default = []

  validation {
    condition = alltrue([
      for item in var.set_values : contains(["auto", "string"], item.type)
    ])
    error_message = "Each set_values type must be either \"auto\" or \"string\"."
  }
}

variable "set_sensitive_values" {
  description = "Sensitive Helm values set by path. Values are redacted from CLI output but remain in Terraform state."
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "auto")
  }))
  default   = []
  sensitive = true

  validation {
    condition = alltrue([
      for item in var.set_sensitive_values : contains(["auto", "string"], item.type)
    ])
    error_message = "Each set_sensitive_values type must be either \"auto\" or \"string\"."
  }
}

variable "atomic" {
  description = "Whether a failed installation is rolled back automatically. Enabling this also enables waiting."
  type        = bool
  default     = true
}

variable "cleanup_on_fail" {
  description = "Whether resources created during a failed upgrade are removed."
  type        = bool
  default     = true
}

variable "dependency_update" {
  description = "Whether Helm updates chart dependencies before installation."
  type        = bool
  default     = false
}

variable "lint" {
  description = "Whether Helm lints the chart during planning."
  type        = bool
  default     = false
}

variable "max_history" {
  description = "Maximum number of Helm release revisions to retain. Zero retains all revisions."
  type        = number
  default     = 10

  validation {
    condition     = var.max_history >= 0 && floor(var.max_history) == var.max_history
    error_message = "max_history must be a non-negative integer."
  }
}

variable "timeout" {
  description = "Seconds to wait for an individual Kubernetes operation."
  type        = number
  default     = 600

  validation {
    condition     = var.timeout > 0 && floor(var.timeout) == var.timeout
    error_message = "timeout must be a positive integer."
  }
}

variable "wait" {
  description = "Whether Terraform waits for all release resources to become ready."
  type        = bool
  default     = true
}

variable "wait_for_jobs" {
  description = "Whether Terraform waits for release jobs to complete when wait is enabled."
  type        = bool
  default     = true
}
