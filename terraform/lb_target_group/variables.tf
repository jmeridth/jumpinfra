variable "name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "lb_arn" {
  type        = string
  description = "LB ARN"
}

variable "default_tls_cert_arn" {
  type        = string
  description = "The ARN of the default certificate that the LB uses for https"
}

variable "additional_tls_cert_arns" {
  type        = list(any)
  description = "The ARNs of the additional certificates that the LB uses for https"
}

variable "health_interval" {
  type        = string
  description = "Path to check if the service is healthy, e.g. \"/status\""
  default     = "30"
}

variable "health_protocol" {
  type        = string
  description = "Path to check if the service is healthy, e.g. \"/status\""
  default     = "HTTP"
}

variable "health_matcher" {
  type        = string
  description = "Path to check if the service is healthy, e.g. \"/status\""
  default     = "200"
}

variable "health_timeout" {
  type        = string
  description = "Path to check if the service is healthy, e.g. \"/status\""
  default     = "3"
}

variable "health_path" {
  type        = string
  description = "Path to check if the service is healthy, e.g. \"/health\""
  default     = "/health"
}

variable "health_unhealthy_threshold" {
  type        = string
  description = "Path to check if the service is unhealthy, e.g. \"/status\""
  default     = "2"
}

variable "health_healthy_threshold" {
  type        = string
  description = "Path to check if the service is healthy, e.g. \"/status\""
  default     = "3"
}
