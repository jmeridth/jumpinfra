variable "name" {
  type        = string
  description = "Stack name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}
