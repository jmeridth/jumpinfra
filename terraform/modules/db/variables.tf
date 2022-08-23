variable "engine" {
  type        = string
  description = "Database engine"
}

variable "engine_version" {
  type        = string
  description = "Database engine version"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "instance_class" {
  type        = string
  description = "Database instance class"
}

variable "password" {
  type        = number
  description = "Database password"
  sensitive   = true
}

variable "port" {
  type        = number
  description = "Database port"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID"
}

variable "stack_name" {
  type        = string
  default     = "jumpco"
  description = "Application name (default: jumpco)"
}

variable "username" {
  type        = number
  description = "Database user"
  sensitive   = true
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}
