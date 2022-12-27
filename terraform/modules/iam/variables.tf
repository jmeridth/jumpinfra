variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS Region (default: us-west-2)"
}

variable "stack_name" {
  type        = string
  default     = "jumpco"
  description = "Application name (default: jumpco)"
}
