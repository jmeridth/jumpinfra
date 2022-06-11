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
  description = "Approximate amount of time, in seconds, between health checks of an individual target"
  default     = "30"
}

variable "health_protocol" {
  type        = string
  description = "Protocol to use to connect with the target"
  default     = "HTTP"
}

variable "health_matcher" {
  type        = string
  description = "Response codes to check if the service is healthy, e.g. \"/status\""
  default     = "200"
}

variable "health_timeout" {
  type        = string
  description = "Amount of time, in seconds, during which no response means a failed health check"
  default     = "3"
}

variable "health_path" {
  type        = string
  description = "Destination for the health check request"
  default     = "/health"
}

variable "health_unhealthy_threshold" {
  type        = string
  description = "Number of consecutive health check failures required before considering the target unhealthy"
  default     = "2"
}

variable "health_healthy_threshold" {
  type        = string
  description = "Number of consecutive health checks successes required before considering an unhealthy target healthy"
  default     = "3"
}
