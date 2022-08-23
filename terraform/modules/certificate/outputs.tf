output "arn" {
  value = var.existing ? (
    data.aws_acm_certificate.certificate[*].arn) : (
  aws_acm_certificate.certificate[*].arn)
}
