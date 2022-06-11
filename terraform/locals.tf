locals {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  api_env_vars = merge(
    var.api_env_vars,
    tomap({
      "AWS_S3_BUCKET"       = module.s3.bucket_name,
      "REDIRECT_URL"        = "https://${var.environment}.jump.co",
      "ROLLBAR_ENVIRONMENT" = "jump-api-${var.environment}",
      "TYPEORM_HOST"        = module.db.aws_db_address,
      "TYPEORM_DATABASE"    = "${var.stack_name}${var.environment}"
    })
  )
  admin_env_vars = merge(
    var.admin_env_vars,
    tomap({
      "TYPEORM_HOST"     = module.db.aws_db_address,
      "TYPEORM_DATABASE" = "${var.stack_name}${var.environment}"
      "AWS_S3_BUCKET"    = module.s3.bucket_name
    })
  )
  web_env_vars = merge(
    var.web_env_vars,
    tomap({
      "NEXT_PUBLIC_BACKEND_URL" = "https://api.${var.environment}.jump.co/v1"
    })
  )
  api_name             = "api"
  api_container_port   = "3001"
  admin_name           = "admin"
  admin_container_port = "3001"
  web_name             = "web"
  web_container_port   = "3000"
}
