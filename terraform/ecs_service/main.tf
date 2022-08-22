terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_iam_policy" "parameter_store" {
  count       = var.logging ? 0 : 1
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
  count      = var.logging ? 0 : 1
  role       = var.ecs_task_execution_role_name
  policy_arn = aws_iam_policy.parameter_store[0].arn
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.name}-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
  memory                   = var.container_memory
  cpu                      = var.container_cpu
  container_definitions    = var.logging ? jsonencode(local.logging_container_definitions) : jsonencode(local.app_container_definitions)
  dynamic "volume" {
    for_each = var.logging ? [1] : []
    content {
      name      = local.logging_volume_name
      host_path = local.logging_path
    }
  }

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

  dynamic "ordered_placement_strategy" {
    for_each = var.logging ? [1] : []
    content {
      type  = "spread"
      field = "instanceId"
    }
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
  count              = var.logging ? 0 : 1
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  count              = var.logging ? 0 : 1
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

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
  count              = var.logging ? 0 : 1
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

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
  count                = var.logging ? 0 : 1
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
  count                = var.logging ? 0 : 1
  name_prefix          = "${var.name}-${var.environment}-"
  vpc_zone_identifier  = var.subnets.*.id
  launch_configuration = aws_launch_configuration.ecs_launch_config[0].name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"

  lifecycle {
    create_before_destroy = true
  }
}
