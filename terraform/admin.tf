module "admin" {
  source                       = "./ecs_service"
  name                         = local.admin_name
  environment                  = var.environment
  ami                          = data.aws_ami.ecs_optimized.id
  cluster_id                   = aws_ecs_cluster.main.id
  cluster_name                 = aws_ecs_cluster.main.name
  aws_lb_target_group_arn      = aws_lb_target_group.admin_target_group.arn
  container_image              = "${module.api_ecr.aws_ecr_repository_url}:latest"
  container_env_vars           = local.admin_env_vars
  container_port               = local.admin_container_port
  container_cpu                = 512
  container_memory             = 1024
  container_secrets            = module.admin_secrets.secrets
  ecs_service_security_groups  = [aws_security_group.admin_ecs_tasks.id]
  ecs_task_execution_role_name = aws_iam_role.ecs_task_execution_role.name
  ecs_task_execution_role_arn  = aws_iam_role.ecs_task_execution_role.arn
  ecs_task_role_arn            = aws_iam_role.ecs_task_role.arn
  instance_profile             = aws_iam_instance_profile.ecs_agent.name
  service_desired_count        = 2
  subnets                      = aws_subnet.private
}

resource "aws_security_group" "admin_ecs_tasks" {
  name   = "${local.admin_name}-sg-task-${var.environment}"
  vpc_id = aws_vpc.main.id

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

  lifecycle {
    create_before_destroy = true
  }
}

module "admin_secrets" {
  source        = "./secrets"
  name          = local.admin_name
  environment   = var.environment
  secret_keys   = var.admin_secrets_keys
  secret_values = var.admin_secrets
}

resource "aws_lb_target_group" "admin_target_group" {
  name        = "${local.admin_name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    interval            = "180"
    matcher             = "200"
    path                = "/health"
    port                = local.admin_container_port
    protocol            = "HTTP"
    timeout             = "120"
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
  listener_arn = aws_lb_listener.https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin_target_group.arn
  }

  condition {
    host_header {
      values = ["admin.${var.environment}.jump.co"]
    }
  }

}
