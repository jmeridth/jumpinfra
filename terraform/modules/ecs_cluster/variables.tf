variable "ecs_task_encrypt_json" {
  type        = string
  description = "JSON for the ECS Task Encrypt Policy"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "stack_name" {
  type        = string
  default     = "jumpco"
  description = "Application name (default: jumpco)"
}
