terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_lb" "main" {
  name               = "${var.name}-lb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = var.subnets.*.id

  enable_deletion_protection = false

  tags = {
    Name = "${var.name}-lb-${var.environment}"
  }
}

resource "aws_security_group" "lb" {
  name   = "${var.name}-sg-lb-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name}-sg-lb-${var.environment}"
  }
}

# Redirect to https listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
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
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.default_tls_cert_arn

  default_action {
    target_group_arn = var.default_target_group_arn
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "additional" {
  count           = length(var.additional_tls_cert_arns)
  certificate_arn = element(var.additional_tls_cert_arns, count.index)
  listener_arn    = aws_lb_listener.https.arn
}
