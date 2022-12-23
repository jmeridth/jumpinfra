resource "aws_acm_certificate" "jump" {
  domain_name       = var.domain_name
  validation_method = var.verification_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "jump" {
  certificate_arn         = aws_acm_certificate.jump.arn
  validation_record_fqdns = [var.route53_record_fqdn]
}
