terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_db_instance" "jump" {
  allocated_storage   = var.allocated_storage
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  db_name             = "${var.name}${var.environment}"
  skip_final_snapshot = var.skip_final_snapshot
  username            = var.username
  password            = var.password

  tags = {
    Name = var.name
  }
}
