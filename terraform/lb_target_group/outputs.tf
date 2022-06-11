output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "aws_lb_listener_https_arn" {
  value = aws_lb_listener.https.arn
}
