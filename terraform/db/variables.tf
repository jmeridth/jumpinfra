variable "name" {
  type        = string
  description = "Application name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "environment" {
  type        = string
  description = "Envrionment"
}

variable "port" {
  type        = string
  description = "The port on which the DB accepts connections"
}

variable "allocated_storage" {
  type        = number
  description = "DB allocated storage"
}

variable "engine" {
  type        = string
  description = "DB engine"
}

variable "engine_version" {
  type        = string
  description = "DB engine version"
}

variable "instance_class" {
  type        = string
  description = "DB instance class"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot (true/false)"
  default     = true
}

variable "username" {
  type        = string
  description = "DB username"
  sensitive   = true
}

variable "password" {
  type        = string
  description = "DB password"
  sensitive   = true
}

variable "private_security_group_ids" {
  type        = list(string)
  description = "List of private security groups to associate"
}

variable "private_subnets_ids" {
  type        = list(any)
  description = "List of private subnet IDs"
}
