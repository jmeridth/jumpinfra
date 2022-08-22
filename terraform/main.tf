terraform {
  # should match .tool-versions in root of repo
  required_version = "1.2.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Service     = "jump"
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_acm_certificate" "api" {
  domain_name       = "api.test.jump.co"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "admin" {
  domain_name       = "admin.test.jump.co"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "web" {
  domain_name       = "test.jump.co"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

module "s3" {
  source      = "./s3"
  name        = var.stack_name
  environment = var.environment
  acl         = "public-read"
}
