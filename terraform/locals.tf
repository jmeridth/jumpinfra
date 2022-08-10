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
  api_name           = "api"
  api_container_port = "3001"
  api_env_vars = merge(
    var.api_env_vars,
    tomap({
      "AWS_S3_BUCKET"    = module.s3.bucket_name,
      "TYPEORM_HOST"     = aws_db_instance.jump.address,
      "TYPEORM_DATABASE" = "${var.stack_name}${var.environment}"
    })
  )
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  db_name            = "${var.stack_name}${var.environment}"
  debugger_name      = "debugger"
  non_web_cert_arns  = [aws_acm_certificate.api.arn, aws_acm_certificate.admin.arn]
  web_container_port = "3000"
  web_name           = "web"
}
