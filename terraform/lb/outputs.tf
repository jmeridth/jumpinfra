output "aws_lb_arn" {
  value = aws_lb.main.arn
}

output "aws_lb_listener_https_arn" {
  value = aws_lb_listener.https.arn
}
