module "web_ecr" {
  source      = "./ecr"
  name        = local.web_name
  environment = var.environment
}

module "web" {
  source                       = "./ecs_service"
  name                         = local.web_name
  environment                  = var.environment
  cluster_id                   = aws_ecs_cluster.main.id
  cluster_name                 = aws_ecs_cluster.main.name
  aws_lb_target_group_arn      = aws_lb_target_group.web_target_group.arn
  container_image              = module.web_ecr.aws_ecr_repository_url
  container_env_vars           = var.web_env_vars
  container_port               = local.web_container_port
  container_cpu                = 256
  container_memory             = 512
  container_secrets            = module.web_secrets.secrets
  ecs_service_security_groups  = [aws_security_group.web_ecs_tasks.id]
  iam_policy_encrypt_logs_json = data.aws_iam_policy_document.ecs_task_encrypt_logs.json
  region                       = var.aws_region
  service_desired_count        = 2
  subnets                      = aws_subnet.private
  ecs_task_execution_role_name = aws_iam_role.ecs_task_execution_role.name
  ecs_task_execution_role_arn  = aws_iam_role.ecs_task_execution_role.arn
  ecs_task_role_arn            = aws_iam_role.ecs_task_role.arn
}

resource "aws_security_group" "web_ecs_tasks" {
  name   = "${local.web_name}-sg-task-${var.environment}"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = local.web_container_port
    to_port          = local.web_container_port
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
    Name = "${local.web_name}-sg-task-${var.environment}"
  }
}

module "web_secrets" {
  source        = "./secrets"
  name          = local.web_name
  environment   = var.environment
  secret_keys   = var.web_secrets_keys
  secret_values = var.web_secrets
}

resource "aws_lb_target_group" "web_target_group" {
  name        = "${local.web_name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "180"
    matcher             = "200"
    path                = "/"
    port                = local.web_container_port
    protocol            = "HTTP"
    timeout             = "120"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "${local.web_name}-tg-${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "web" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }

  condition {
    host_header {
      values = ["${var.environment}.jump.co"]
    }
  }
}
