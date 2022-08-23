variable "domain_name" {
  type        = string
  description = "Certificate Domain name"
}

variable "existing" {
  type        = bool
  default     = false
  description = "Use existing certificate"
}

variable "verification_method" {
  type        = string
  default     = "DNS"
  description = "Certificate verification method"
}
