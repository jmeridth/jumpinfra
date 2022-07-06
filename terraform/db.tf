resource "aws_db_instance" "jump" {
  identifier           = var.stack_name
  allocated_storage    = 10
  port                 = var.api_env_vars["TYPEORM_PORT"]
  engine               = var.api_env_vars["TYPEORM_CONNECTION"]
  engine_version       = var.api_env_vars["DB_ENGINE_VERSION"]
  instance_class       = var.api_env_vars["DB_INSTANCE_CLASS"]
  db_name              = local.db_name
  skip_final_snapshot  = true
  username             = var.api_secrets["TYPEORM_USERNAME"]
  password             = var.api_secrets["TYPEORM_PASSWORD"]
  db_subnet_group_name = aws_db_subnet_group.private.id
  vpc_security_group_ids = [
    aws_security_group.db.id,
    aws_security_group.api_ecs_tasks.id,
    aws_security_group.admin_ecs_tasks.id
  ]

  tags = {
    Name = var.stack_name
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "private"
  subnet_ids = aws_subnet.private.*.id

  tags = {
    Name = "private"
  }
}

resource "aws_security_group" "db" {
  name   = "${var.stack_name}-sg-db-${var.environment}"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = var.api_env_vars["TYPEORM_PORT"]
    protocol  = "tcp"
    security_groups = [
      aws_security_group.api_ecs_tasks.id,
      aws_security_group.admin_ecs_tasks.id
    ]
    self    = "false"
    to_port = var.api_env_vars["TYPEORM_PORT"]
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
