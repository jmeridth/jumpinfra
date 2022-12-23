output "ecs_agent_name" {
  value = aws_iam_role.ecs_agent.name
}

output "ecs_task_encrypt_json" {
  value = data.aws_iam_policy_document.ecs_task_encrypt.json
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_execution_role_name" {
  value = aws_iam_role.ecs_task_execution_role.name
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}
