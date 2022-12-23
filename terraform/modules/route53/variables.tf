variable "name" {
  type        = string
  description = "Application name"
  default     = "jumpco"
}

variable "record_name" {
  type        = string
  description = "DNS record name"
}

variable "lb_dns_name" {
  type        = string
  description = "Load balancer DNS name"
}

variable "lb_zone_id" {
  type        = string
  description = "Load balancer zone ID"
}
