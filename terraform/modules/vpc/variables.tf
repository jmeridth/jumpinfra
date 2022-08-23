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

variable "environment" {
  type        = string
  description = "Environment"
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

variable "stack_name" {
  type        = string
  default     = "jumpco"
  description = "Application name (default: jumpco)"
}
