terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_db_instance" "jump" {
  identifier             = var.name
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = local.db_name
  port                   = var.port
  skip_final_snapshot    = var.skip_final_snapshot
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.private.id
  vpc_security_group_ids = var.private_security_group_ids

  tags = {
    Name = var.name
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "private"
  subnet_ids = var.private_subnets_ids

  tags = {
    Name = "private"
  }
}

resource "aws_security_group" "db" {
  name   = "${var.name}-sg-db-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.port
    protocol        = "tcp"
    security_groups = var.private_security_group_ids
    self            = "false"
    to_port         = var.port
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name}-sg-db-${var.environment}"
  }
}
