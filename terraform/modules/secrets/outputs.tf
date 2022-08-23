output "secrets" {
  value = [for s in aws_ssm_parameter.parameter : { name = regex(".*\\/(.*)$", s.name)[0], valueFrom = s.arn }]
}
