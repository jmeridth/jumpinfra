resource "aws_acm_certificate" "certificate" {
  count             = var.existing ? 0 : 1
  domain_name       = var.domain_name
  validation_method = var.verification_method

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_acm_certificate" "certificate" {
  count    = var.existing ? 1 : 0
  domain   = var.domain_name
  statuses = ["ISSUED"]
}
