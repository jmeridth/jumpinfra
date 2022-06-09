terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_lb" "main" {
  name               = "${var.name}-lb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets.*.id

  enable_deletion_protection = false

  tags = {
    Name = "${var.name}-lb-${var.environment}"
  }
}
