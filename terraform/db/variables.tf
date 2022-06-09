variable "name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Envrionment"
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
