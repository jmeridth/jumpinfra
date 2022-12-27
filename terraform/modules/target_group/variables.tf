variable "container_port" {
  type        = string
  description = "Container port"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "healthy_threshold" {
  type        = string
  default     = "3"
  description = "Healthy threshold"
}

variable "name" {
  type        = string
  description = "Name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}
