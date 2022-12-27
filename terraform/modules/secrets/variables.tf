variable "name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "secret_keys" {
  type        = set(string)
  description = "Keys for the secrets"
}

variable "secret_values" {
  type        = map(string)
  description = "Values for the secrets"
  sensitive   = true
}
