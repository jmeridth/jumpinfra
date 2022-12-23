variable "domain_name" {
  type        = string
  description = "Certificate Domain name"
}

variable "route53_record_fqdn" {
  type        = string
  description = "Route53 record FQDN"
}

variable "verification_method" {
  type        = string
  default     = "DNS"
  description = "Certificate verification method"
}
