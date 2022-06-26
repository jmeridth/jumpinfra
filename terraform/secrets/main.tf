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

resource "aws_ssm_parameter" "parameter" {
  for_each    = var.secret_keys
  name        = "/${var.environment}/${var.name}/${each.key}"
  description = "${var.environment} environment ${var.name} app ${each.key} secret"
  type        = "SecureString"
  value       = var.secret_values[each.key]
}
