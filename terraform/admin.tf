module "admin" {
  source                       = "./ecs"
  name                         = local.admin_name
  environment                  = var.environment
  cluster_id                   = aws_ecs_cluster.main.id
  cluster_name                 = aws_ecs_cluster.main.name
  aws_lb_target_group_arn      = aws_lb_target_group.admin_target_group.arn
  container_image              = module.api_ecr.aws_ecr_repository_url
  container_env_vars           = local.admin_env_vars
  container_port               = local.admin_container_port
  container_cpu                = 256
  container_memory             = 512
  container_secrets            = module.admin_secrets.secrets_map
  container_secrets_arn        = module.admin_secrets.secrets_arn
  ecs_service_security_groups  = [aws_security_group.admin_ecs_tasks.id]
  region                       = var.aws_region
  service_desired_count        = 2
  subnets                      = module.vpc.private_subnets
  ecs_task_execution_role_name = aws_iam_role.ecs_task_execution_role.name
  ecs_task_execution_role_arn  = aws_iam_role.ecs_task_execution_role.arn
  ecs_task_role_arn            = aws_iam_role.ecs_task_role.arn
}

resource "aws_security_group" "admin_ecs_tasks" {
  name   = "${local.admin_name}-sg-task-${var.environment}"
  vpc_id = module.vpc.id

  ingress {
    protocol         = "tcp"
    from_port        = local.admin_container_port
    to_port          = local.admin_container_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.admin_name}-sg-task-${var.environment}"
  }
}

module "admin_secrets" {
  source      = "./secrets"
  name        = local.admin_name
  environment = var.environment
  secrets     = var.admin_secrets
}

resource "aws_lb_target_group" "admin_target_group" {
  name        = "${local.admin_name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "180"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "120"
    path                = "/health"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "${local.api_name}-tg-${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "admin" {
  listener_arn = module.lb.aws_lb_listener_https_arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/admin"]
    }
  }

  condition {
    host_header {
      values = ["api.${var.environment}.jump.co"]
    }
  }
}
