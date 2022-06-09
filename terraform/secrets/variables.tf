variable "name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "secrets" {
  type        = map(any)
  description = "A map of secrets that is passed into the application. Formatted like ENV_VAR = VALUE"
  sensitive   = true
}
