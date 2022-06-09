output "lb" {
  value = aws_security_group.lb.id
}

output "ecs_tasks" {
  value = aws_security_group.ecs_tasks.id
}
