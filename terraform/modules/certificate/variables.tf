variable "domain_name" {
  type        = string
  description = "Certificate Domain name"
}

variable "verification_method" {
  type        = string
  default     = "DNS"
  description = "Certificate verification method"
}
