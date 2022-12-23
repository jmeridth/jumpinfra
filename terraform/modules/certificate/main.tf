resource "aws_acm_certificate" "jump" {
  domain_name       = var.domain_name
  validation_method = var.verification_method

  lifecycle {
    create_before_destroy = true
  }
}
