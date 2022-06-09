module "admin" {
  source                      = "./ecs"
  name                        = local.admin_name
  environment                 = var.environment
  cluster_id                  = aws_ecs_cluster.main.id
  cluster_name                = aws_ecs_cluster.main.name
  aws_lb_target_group_arn     = module.lb_target_group.aws_lb_target_group_arn
  container_image             = "${module.api_ecr.aws_ecr_repository_url}/api-${var.environment}"
  container_env_vars          = local.admin_env_vars
  container_port              = local.admin_container_port
  container_cpu               = 256
  container_memory            = 512
  container_secrets           = module.admin_secrets.secrets_map
  container_secrets_arn       = module.admin_secrets.secrets_arn
  ecs_service_security_groups = [module.admin_security_groups.ecs_tasks]
  region                      = var.aws_region
  service_desired_count       = 2
  subnets                     = module.vpc.private_subnets
}

module "admin_security_groups" {
  source         = "./security_groups"
  name           = local.admin_name
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = local.admin_container_port
}

module "admin_secrets" {
  source      = "./secrets"
  name        = local.admin_name
  environment = var.environment
  secrets     = var.admin_secrets
}
