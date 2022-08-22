module "logging" {
  source                       = "./ecs_service"
  name                         = local.logging_name
  environment                  = var.environment
  ami                          = data.aws_ami.ecs_optimized.id
  cluster_id                   = aws_ecs_cluster.main.id
  cluster_name                 = aws_ecs_cluster.main.name
  container_image              = "gliderlabs/logspout:latest"
  container_cpu                = 256
  container_memory             = 512
  ecs_service_security_groups  = local.all_app_security_groups
  ecs_task_execution_role_name = aws_iam_role.ecs_task_execution_role.name
  ecs_task_execution_role_arn  = aws_iam_role.ecs_task_execution_role.arn
  ecs_task_role_arn            = aws_iam_role.ecs_task_role.arn
  instance_profile             = aws_iam_instance_profile.ecs_agent.name
  logging                      = true
  service_desired_count        = 3
  subnets                      = aws_subnet.private
}
