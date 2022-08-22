resource "aws_ecs_cluster" "main" {
  name = "${var.stack_name}-cluster-${var.environment}"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.ecs_cluster.arn
    }
  }
  tags = {
    Name = "${var.stack_name}-cluster-${var.environment}"
  }
}

resource "aws_kms_key" "ecs_cluster" {
  description             = "This key is used to encrypt communication between client and ecs tasks"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.ecs_task_encrypt.json

  tags = {
    Name = "${var.stack_name}-cluster-key-${var.environment}"
  }
}

resource "aws_kms_alias" "ecs_cluster_key_alias" {
  name          = "alias/terraform-ecs-cluster-key-${var.environment}"
  target_key_id = aws_kms_key.ecs_cluster.key_id
}

resource "aws_ecs_account_setting_default" "vpc_trunking" {
  name  = "awsvpcTrunking"
  value = "enabled"
}
