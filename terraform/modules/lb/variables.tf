variable "api_certificate_arn" {
  type        = string
  description = "ARN for API certificate"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "path_patterns_listener_rules" {
  type = list(object({
    name             = string
    host_headers     = list(string)
    path_patterns    = list(string)
    priority         = number
    target_group_arn = string
  }))
  description = "List of normal listener rules"
}

variable "listener_rules" {
  type = list(object({
    name             = string
    host_headers     = list(string)
    priority         = number
    target_group_arn = string
  }))
  description = "List of normal listener rules"
}

variable "public_subnets" {
  type = list(object({
    id = string
  }))
  description = "List of public subnets"
}

variable "stack_name" {
  type        = string
  default     = "jumpco"
  description = "Application name (default: jumpco)"
}

variable "web_certificate_arn" {
  type        = string
  description = "ARN for WEB certificate"
}

variable "web_target_group_arn" {
  type        = string
  description = "Web target group ARN"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}
