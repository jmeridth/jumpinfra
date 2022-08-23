resource "aws_db_instance" "jump" {
  identifier           = var.stack_name
  allocated_storage    = 10
  port                 = var.port
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name              = local.db_name
  skip_final_snapshot  = true
  username             = var.username
  password             = var.password
  db_subnet_group_name = aws_db_subnet_group.private.id
  vpc_security_group_ids = [
    aws_security_group.db.id,
    var.security_group_id
  ]

  tags = {
    Name = var.stack_name
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "private"
  subnet_ids = var.private_subnets

  tags = {
    Name = "private"
  }
}

resource "aws_security_group" "db" {
  name   = "${var.stack_name}-sg-db-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.port
    protocol        = "tcp"
    security_groups = [var.security_group_id]
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
    Name = "${var.stack_name}-sg-db-${var.environment}"
  }
}
