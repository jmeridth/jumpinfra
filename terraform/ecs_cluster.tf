resource "aws_ecs_cluster" "main" {
  name = "${var.stack_name}-cluster-${var.environment}"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.ecs_cluster.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cluster.name
      }
    }
  }
  tags = {
    Name = "${var.stack_name}-cluster-${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "ecs_cluster" {
  name       = "/ecs/${var.stack_name}-cluster-${var.environment}"
  kms_key_id = aws_kms_key.ecs_cluster.arn
  tags = {
    Name = "${var.stack_name}-cluster-${var.environment}"
  }
}

resource "aws_kms_key" "ecs_cluster" {
  description             = "This key is used to encrypt communication between client and ecs tasks"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.ecs_task_encrypt_logs.json

  tags = {
    Name = "${var.stack_name}-cluster-key-${var.environment}"
  }
}

resource "aws_kms_alias" "ecs_cluster_key_alias" {
  name          = "alias/terraform-ecs-cluster-key-${var.environment}"
  target_key_id = aws_kms_key.ecs_cluster.key_id
}
