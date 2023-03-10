resource "aws_lb" "main" {
  name               = "${var.stack_name}-lb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = [for subnet in var.public_subnets : subnet.id]

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "${var.environment}-lb"
    enabled = true
  }

  enable_deletion_protection = false

  tags = {
    Name = "${var.stack_name}-lb-${var.environment}"
  }
}

resource "aws_security_group" "lb" {
  name   = "${var.stack_name}-sg-lb-${var.environment}"
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

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.stack_name}-sg-lb-${var.environment}"
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
  certificate_arn = var.web_certificate_arn

  default_action {
    target_group_arn = var.web_target_group_arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "endpoint" {
  for_each = { for rule in var.listener_rules : rule.name => rule }

  listener_arn = aws_lb_listener.https.arn
  priority     = each.value["priority"]

  action {
    type             = "forward"
    target_group_arn = each.value["target_group_arn"]
  }

  condition {
    host_header {
      values = each.value["host_headers"]
    }
  }
}

resource "aws_lb_listener_rule" "health" {
  for_each = { for rule in var.path_patterns_listener_rules : rule.name => rule }

  listener_arn = aws_lb_listener.https.arn
  priority     = each.value["priority"]

  action {
    type             = "forward"
    target_group_arn = each.value["target_group_arn"]
  }

  condition {
    path_pattern {
      values = each.value["path_patterns"]
    }
  }

  condition {
    host_header {
      values = each.value["host_headers"]
    }
  }
}

resource "aws_lb_listener_certificate" "additional" {
  certificate_arn = var.api_certificate_arn
  listener_arn    = aws_lb_listener.https.arn
}

resource "aws_s3_bucket" "lb_logs" {
  bucket = "${var.stack_name}-lb-logs-${var.environment}"
}

resource "aws_s3_bucket_acl" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  policy = data.aws_iam_policy_document.lb_logs.json
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "lb_logs" {
  policy_id = "s3_bucket_lb_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.lb_logs.arn}/*",
    ]

    principals {
      identifiers = [data.aws_elb_service_account.main.arn]
      type        = "AWS"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.lb_logs.arn}/*"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect    = "Allow"
    resources = [aws_s3_bucket.lb_logs.arn]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}
