variable "name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "subnets" {
  type        = list(any)
  description = "Comma separated list of subnet IDs"
}

variable "security_groups" {
  type        = list(any)
  description = "Comma separated list of security groups"
}
