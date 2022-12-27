variable "ami" {
  type        = string
  description = "AMI name"
}

variable "aws_lb_target_group_arn" {
  type        = string
  description = "ARN of the load balancer target group"
  default     = ""
}

variable "container_cpu" {
  type        = number
  description = "The number of cpu units used by the task"
}

variable "container_env_vars" {
  type        = map(any)
  description = "The container environmnent variables"
  default     = {}
}

variable "container_image" {
  type        = string
  description = "Docker image to be launched"
}

variable "container_memory" {
  type        = number
  description = "The amount (in MiB) of memory used by the task"
}

variable "container_port" {
  type        = number
  description = "Port of container"
  default     = null
}

variable "container_secrets" {
  type        = list(any)
  description = "The container secret environmnent variables"
  sensitive   = true
  default     = []
}

variable "cluster_id" {
  type        = string
  description = "ID of ECS Cluster"
}

variable "cluster_name" {
  type        = string
  description = "Name of ECS Cluster"
}

variable "ecs_service_security_groups" {
  type        = list(string)
  description = "List of security groups"
}

variable "ecs_task_execution_role_arn" {
  type        = string
  description = "ECS Task Execution Role ARN"
}

variable "ecs_task_execution_role_name" {
  type        = string
  description = "ECS Task Execution Role Name"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "ECS Task Execution Role ARN"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "instance_profile" {
  type        = string
  description = "IAM profile to use for EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "name" {
  type        = string
  description = "Application name"
}

variable "service_desired_count" {
  type        = number
  description = "Number of services running in parallel"
}

variable "ssm_parameter_store_prefix" {
  type        = string
  description = "SSM Parameter Store prefix"
}

variable "subnets" {
  type        = list(any)
  description = "List of subnet IDs"
}

variable "syslog_address" {
  type        = string
  description = "Syslog address"
  default     = "logs3.papertrailapp.com"
}

variable "syslog_port" {
  type        = number
  description = "Syslog port"
  default     = 37939
}

variable "syslog_protocol" {
  type        = string
  description = "Syslog protocol"
  default     = "tcp+tls"
}
