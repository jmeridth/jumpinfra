module "debugger_ecr" {
  count       = var.environment != "production" ? 1 : 0
  source      = "./ecr"
  name        = local.debugger_name
  environment = var.environment
}

module "debugger" {
  count                        = var.environment != "production" ? 1 : 0
  source                       = "./ecs_service"
  name                         = local.debugger_name
  environment                  = var.environment
  ami                          = data.aws_ami.ecs_optimized.id
  cluster_id                   = aws_ecs_cluster.main.id
  cluster_name                 = aws_ecs_cluster.main.name
  container_image              = module.debugger_ecr[count.index].aws_ecr_repository_url
  container_env_vars           = local.api_env_vars
  container_port               = local.api_container_port
  container_cpu                = 512
  container_memory             = 1024
  container_secrets            = module.api_secrets.secrets
  ecs_service_security_groups  = [aws_security_group.api_ecs_tasks.id]
  ecs_task_execution_role_name = aws_iam_role.ecs_task_execution_role.name
  ecs_task_execution_role_arn  = aws_iam_role.ecs_task_execution_role.arn
  ecs_task_role_arn            = aws_iam_role.ecs_task_role.arn
  instance_profile             = aws_iam_instance_profile.ecs_agent.name
  service_desired_count        = 1
  subnets                      = aws_subnet.private
}
