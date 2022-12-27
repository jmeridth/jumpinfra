locals {
  parsed = regex(".*/env/(?P<env>.*?)/.*", get_terragrunt_dir())
  env    = local.parsed.env
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "jumpco-terraform-state-${local.env}"
    dynamodb_table = "terraform-locking-${local.env}"
    key            = "${path_relative_to_include()}/jump-infra/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

inputs = merge(
  yamldecode(file("${find_in_parent_folders("env.yaml", "stack.yaml")}")),
  yamldecode(file("${find_in_parent_folders("app.yaml", "stack.yaml")}")),
)

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-west-2"
  profile = "jump${local.env}"
  default_tags {
    tags = {
      Environment = "${local.env}"
      Service     = "jump"
    }
  }
}
EOF
}

terraform {
  before_hook "before_hook" {
    commands = ["apply", "plan"]
    execute  = ["tflint"]
  }
}
