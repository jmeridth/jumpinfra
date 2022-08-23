resource "aws_lb_target_group" "target_group" {
  name        = "${var.name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.healthy_threshold
    interval            = "180"
    matcher             = "200"
    path                = "/"
    port                = var.container_port
    protocol            = "HTTP"
    timeout             = "120"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "${var.name}-tg-${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
