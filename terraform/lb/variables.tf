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

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}
