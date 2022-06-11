module "api_ecr" {
  source      = "./ecr"
  name        = local.api_name
  environment = var.environment
}

module "api" {
  source                       = "./ecs"
  name                         = local.api_name
  environment                  = var.environment
  cluster_id                   = aws_ecs_cluster.main.id
  cluster_name                 = aws_ecs_cluster.main.name
  aws_lb_target_group_arn      = aws_lb_target_group.api_target_group.arn
  container_image              = module.api_ecr.aws_ecr_repository_url
  container_env_vars           = local.api_env_vars
  container_port               = local.api_container_port
  container_cpu                = 256
  container_memory             = 512
  container_secrets            = module.api_secrets.secrets_map
  container_secrets_arn        = module.api_secrets.secrets_arn
  ecs_service_security_groups  = [aws_security_group.api_ecs_tasks.id]
  region                       = var.aws_region
  service_desired_count        = 2
  subnets                      = module.vpc.private_subnets
  ecs_task_execution_role_name = aws_iam_role.ecs_task_execution_role.name
  ecs_task_execution_role_arn  = aws_iam_role.ecs_task_execution_role.arn
  ecs_task_role_arn            = aws_iam_role.ecs_task_role.arn
}

resource "aws_security_group" "api_ecs_tasks" {
  name   = "${local.api_name}-sg-task-${var.environment}"
  vpc_id = module.vpc.id

  ingress {
    protocol         = "tcp"
    from_port        = local.api_container_port
    to_port          = local.api_container_port
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
    Name = "${local.api_name}-sg-task-${var.environment}"
  }
}

module "api_secrets" {
  source      = "./secrets"
  name        = local.api_name
  environment = var.environment
  secrets     = var.api_secrets
}

resource "aws_lb_target_group" "api_target_group" {
  name        = "${local.api_name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
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

resource "aws_lb_listener_rule" "api" {
  listener_arn = module.lb_target_group.aws_lb_listener_https_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/v1/*"]
    }
  }

  condition {
    host_header {
      values = ["api.${var.environment}.jump.co"]
    }
  }
}
