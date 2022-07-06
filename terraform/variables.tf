variable "environment" {
  type        = string
  description = "Environment"
}

variable "stack_name" {
  type        = string
  default     = "jumpco"
  description = "Application name (default: jumpco)"
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS Region (default: us-west-2)"
}

variable "cidr" {
  type        = string
  description = "VPC CIDR (default: 10.0.0.0/16)"
  default     = "10.10.0.0/16"
}
variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets"
  default     = ["10.10.10.0/24", "10.10.20.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets"
  default     = ["10.10.11.0/24", "10.10.21.0/24"]
}

variable "api_env_vars" {
  type        = map(string)
  default     = {}
  description = "API Environment Variables (default: {})"
}

variable "api_secrets_keys" {
  type        = list(string)
  default     = []
  description = "API Secrets Keys (default: [])"
}

variable "api_secrets" {
  type        = map(string)
  default     = {}
  description = "API Secrets (default: {})"
  sensitive   = true
}

variable "web_env_vars" {
  type        = map(string)
  default     = {}
  description = "Web Environment Variables (default: {})"
}

variable "web_secrets_keys" {
  type        = list(string)
  default     = []
  description = "Web Secrets Keys (default: [])"
}

variable "web_secrets" {
  type        = map(string)
  default     = {}
  description = "Web Secrets (default: {})"
  sensitive   = true
}

variable "admin_env_vars" {
  type        = map(string)
  default     = {}
  description = "Admin Environment Variables (default: {})"
}

variable "admin_secrets_keys" {
  type        = list(string)
  default     = []
  description = "Admin Secrets Keys (default: [])"
}

variable "admin_secrets" {
  type        = map(string)
  default     = {}
  description = "Admin Secrets (default: {})"
  sensitive   = true
}

