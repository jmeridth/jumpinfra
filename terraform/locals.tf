locals {
  admin_name           = "admin"
  admin_container_port = "3001"
  admin_env_vars = merge(
    var.admin_env_vars,
    tomap({
      "TYPEORM_HOST"     = aws_db_instance.jump.address,
      "TYPEORM_DATABASE" = "${var.stack_name}${var.environment}"
      "AWS_S3_BUCKET"    = module.s3.bucket_name
    })
  )
  admin_secret_keys  = keys(var.admin_secrets)
  api_name           = "api"
  api_container_port = "3001"
  api_env_vars = merge(
    var.api_env_vars,
    tomap({
      "AWS_S3_BUCKET"       = module.s3.bucket_name,
      "REDIRECT_URL"        = "https://${var.environment}.jump.co",
      "ROLLBAR_ENVIRONMENT" = "jump-api-${var.environment}",
      "TYPEORM_HOST"        = aws_db_instance.jump.address,
      "TYPEORM_DATABASE"    = "${var.stack_name}${var.environment}"
    })
  )
  api_secret_keys    = keys(var.api_secrets)
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  db_name            = "${var.stack_name}${var.environment}"
  web_container_port = "3000"
  web_env_vars = merge(
    var.web_env_vars,
    tomap({
      "NEXT_PUBLIC_BACKEND_URL" = "https://api.${var.environment}.jump.co/v1"
    })
  )
  web_name        = "web"
  web_secret_keys = keys(var.web_secrets)
}
