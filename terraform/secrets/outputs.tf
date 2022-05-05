output "secrets_arn" {
  value = aws_secretsmanager_secret_version.secrets.arn
}

output "secrets_map" {
  value = local.secret_map
}
