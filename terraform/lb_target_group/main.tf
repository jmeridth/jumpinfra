terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.health_healthy_threshold
    interval            = var.health_interval
    protocol            = var.health_protocol
    matcher             = var.health_matcher
    timeout             = var.health_timeout
    path                = var.health_path
    unhealthy_threshold = var.health_unhealthy_threshold
  }

  tags = {
    Name = "${var.name}-tg-${var.environment}"
  }
}

# Redirect to https listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = var.lb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect traffic to target group
resource "aws_lb_listener" "https" {
  load_balancer_arn = var.lb_arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.default_tls_cert_arn

  default_action {
    target_group_arn = aws_lb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "additional" {
  count           = length(var.additional_tls_cert_arns)
  certificate_arn = element(var.additional_tls_cert_arns, count.index)
  listener_arn    = aws_lb_listener.https.arn
}
