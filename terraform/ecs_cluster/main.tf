terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.name}-cluster-${var.environment}"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.main.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.main.name
      }
    }
  }
  tags = {
    Name = "${var.name}-cluster-${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.name}-cluster-${var.environment}"

  tags = {
    Name = "${var.name}-cluster-${var.environment}"
  }
}

resource "aws_kms_key" "main" {
  description             = "This key is used to encrypt communication between client and ecs tasks"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name = "${var.name}-cluster-key-${var.environment}"
  }
}

resource "aws_kms_alias" "key_alias" {
  name          = "alias/terraform-ecs-cluster-key-${var.environment}"
  target_key_id = aws_kms_key.main.key_id
}
