variable "name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "acl" {
  type        = string
  description = "Bucket ACL: private, public-read, public-read-write"
  default     = "public-read"
}
