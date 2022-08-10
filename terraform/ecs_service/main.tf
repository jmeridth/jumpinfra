terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_iam_policy" "parameter_store" {
  name        = "${var.name}-task-policy-parameter-store"
  description = "Policy that allows access to the parameter store entries we created"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter*",
          "ssm:DescribeParameters*"
        ],
        Resource = "arn:aws:ssm:*:*:parameter/${var.environment}/${var.name}/*"
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment_for_secrets" {
  role       = var.ecs_task_execution_role_name
  policy_arn = aws_iam_policy.parameter_store.arn
}

resource "aws_cloudwatch_log_group" "main" {
  name       = "/ecs/${var.name}-task-${var.environment}"
  kms_key_id = aws_kms_key.ecs_task.arn
  tags = {
    Name = "${var.name}-task-${var.environment}"
  }
}

resource "aws_kms_key" "ecs_task" {
  description             = "This key is used to encrypt communication for ${var.name} ecs service"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = var.iam_policy_encrypt_logs_json

  tags = {
    Name = "${var.name}-ecs-service-key-${var.environment}"
  }
}

resource "aws_kms_alias" "ecs_service_key_alias" {
  name          = "alias/${var.name}-ecs-service-key-${var.environment}"
  target_key_id = aws_kms_key.ecs_task.key_id
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.name}-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
  memory                   = var.container_memory
  cpu                      = var.container_cpu
  container_definitions = jsonencode([{
    name        = local.container_name
    image       = "${var.container_image}:latest"
    essential   = true
    environment = local.container_env_vars
    memory      = var.container_memory
    cpu         = var.container_cpu
    linuxParameters = {
      initProcessEnabled = true
    }
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
    secrets = var.container_secrets
  }])

  tags = {
    Name = "${var.name}-task-${var.environment}"
  }
}

resource "aws_ecs_service" "main" {
  name                               = "${var.name}-${var.environment}"
  cluster                            = var.cluster_id
  enable_execute_command             = true
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.service_desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = var.aws_lb_target_group_arn != "" ? 60 : null
  launch_type                        = "EC2"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.subnets.*.id
    assign_public_ip = false
  }

  dynamic "load_balancer" {
    for_each = var.aws_lb_target_group_arn != "" ? [1] : []
    content {
      target_group_arn = var.aws_lb_target_group_arn
      container_name   = local.container_name
      container_port   = var.container_port
    }
  }

  # desired_count is ignored as it can change due to autoscaling policy
  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
  name_prefix          = "${var.name}-${var.environment}-"
  image_id             = var.ami
  iam_instance_profile = var.instance_profile
  security_groups      = var.ecs_service_security_groups
  user_data            = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
EOF
  instance_type        = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "${var.name}-${var.environment}"
  vpc_zone_identifier  = var.subnets.*.id
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"

  lifecycle {
    create_before_destroy = true
  }
}
