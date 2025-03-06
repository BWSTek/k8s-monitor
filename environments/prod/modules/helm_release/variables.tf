variable "leantime_namespace" {
  description = "Namespace for leantime"
  type        = string
}

variable "openproject_namespace" {
  description = "Namespace for openproject"
  type        = string
}

variable "vikunja_namespace" {
  description = "Namespace for vikunja"
  type        = string
}

variable "repository" {
  description = "Helm chart repository"
  type        = map(string)
}

variable "values" {
  description = "Values files for the Helm releases"
  type        = map(string)
}
