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

variable "default_target_group_arn" {
  type        = string
  description = "Default target group ARN"
}

variable "default_tls_cert_arn" {
  type        = string
  description = "The ARN of the default certificate that the LB uses for https"
}

variable "additional_tls_cert_arns" {
  type        = list(any)
  description = "The ARNs of the additional certificates that the LB uses for https"
}
