terraform {
  # should match .tool-versions in root of repo
  required_version = "1.2.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  #backend "s3" {}
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

module "vpc" {
  source             = "./vpc"
  name               = var.stack_name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = local.availability_zones
  environment        = var.environment
}

module "lb" {
  source      = "./lb"
  name        = var.stack_name
  subnets     = module.vpc.public_subnets
  environment = var.environment
  vpc_id      = module.vpc.id
}

module "lb_target_group" {
  source                   = "./lb_target_group"
  name                     = var.stack_name
  environment              = var.environment
  lb_arn                   = module.lb.aws_lb_arn
  default_tls_cert_arn     = aws_acm_certificate.web.arn
  additional_tls_cert_arns = [aws_acm_certificate.api.arn]
  vpc_id                   = module.vpc.id
}

module "db" {
  source              = "./db"
  name                = var.stack_name
  vpc_id              = module.vpc.id
  environment         = var.environment
  allocated_storage   = 10
  port                = var.api_env_vars["TYPEORM_PORT"]
  engine              = var.api_env_vars["TYPEORM_CONNECTION"]
  engine_version      = var.api_env_vars["DB_ENGINE_VERSION"]
  instance_class      = var.api_env_vars["DB_INSTANCE_CLASS"]
  skip_final_snapshot = true
  username            = var.api_secrets["TYPEORM_USERNAME"]
  password            = var.api_secrets["TYPEORM_PASSWORD"]
  private_subnets_ids = module.vpc.private_subnets.*.id
  private_security_group_ids = [
    aws_security_group.api_ecs_tasks.id,
    aws_security_group.admin_ecs_tasks.id
  ]
}

resource "aws_acm_certificate" "api" {
  domain_name       = "api.test.jump.co"
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

resource "aws_ecs_cluster" "main" {
  name = "${var.stack_name}-cluster-${var.environment}"
  tags = {
    Name = "${var.stack_name}-cluster-${var.environment}"
  }
}
