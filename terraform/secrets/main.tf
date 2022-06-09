# Do not put any secrets in here (aka source control)
# Put them in secrets.[ENV].tfvars

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_secretsmanager_secret" "secrets" {
  name                    = "${var.name}-secrets-${var.environment}"
  recovery_window_in_days = 0

  tags = {
    "Name" = "${var.name}-secrets-${var.environment}"
  }
}


resource "aws_secretsmanager_secret_version" "secrets" {
  secret_id     = aws_secretsmanager_secret.secrets.id
  secret_string = jsonencode(var.secrets)
}


locals {
  secret_map = [{
    name      = "${var.name}-secrets-${var.environment}"
    valueFrom = aws_secretsmanager_secret_version.secrets.arn
  }]
}
