variable "name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "region" {
  type        = string
  description = "the AWS region in which resources are created"
}

variable "iam_policy_encrypt_logs_json" {
  type        = string
  description = "IAM Policy JSON for ECS Task ecryption with KMS key"
}

variable "cluster_name" {
  type        = string
  description = "Name of ECS Cluster"
}

variable "cluster_id" {
  type        = string
  description = "ID of ECS Cluster"
}

variable "subnets" {
  type        = list(any)
  description = "List of subnet IDs"
}

variable "ecs_task_execution_role_arn" {
  type        = string
  description = "ECS Task Execution Role ARN"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "ECS Task Execution Role ARN"
}

variable "ecs_task_execution_role_name" {
  type        = string
  description = "ECS Task Execution Role Name"
}

variable "ecs_service_security_groups" {
  type        = list(string)
  description = "List of security groups"
}

variable "container_port" {
  type        = number
  description = "Port of container"
}

variable "container_cpu" {
  type        = number
  description = "The number of cpu units used by the task"
}

variable "container_memory" {
  type        = number
  description = "The amount (in MiB) of memory used by the task"
}

variable "container_image" {
  type        = string
  description = "Docker image to be launched"
}

variable "aws_lb_target_group_arn" {
  type        = string
  description = "ARN of the load balancer target group"
}

variable "service_desired_count" {
  type        = number
  description = "Number of services running in parallel"
}

variable "container_env_vars" {
  type        = map(any)
  description = "The container environmnent variables"
}

variable "container_secrets" {
  type        = list(any)
  description = "The container secret environmnent variables"
  sensitive   = true
}

locals {
  container_env_vars = [for k, v in var.container_env_vars : {
    name  = k
    value = v
  }]
}