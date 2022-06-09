module "api_ecr" {
  source      = "./ecr"
  name        = local.api_name
  environment = var.environment
}

module "api" {
  source                      = "./ecs"
  name                        = local.api_name
  environment                 = var.environment
  cluster_id                  = aws_ecs_cluster.main.id
  cluster_name                = aws_ecs_cluster.main.name
  aws_lb_target_group_arn     = module.lb_target_group.aws_lb_target_group_arn
  container_image             = "${module.api_ecr.aws_ecr_repository_url}/api-${var.environment}"
  container_env_vars          = local.api_env_vars
  container_port              = local.api_container_port
  container_cpu               = 256
  container_memory            = 512
  container_secrets           = module.api_secrets.secrets_map
  container_secrets_arn       = module.api_secrets.secrets_arn
  ecs_service_security_groups = [module.api_security_groups.ecs_tasks]
  region                      = var.aws_region
  service_desired_count       = 2
  subnets                     = module.vpc.private_subnets
}

module "api_security_groups" {
  source         = "./security_groups"
  name           = local.api_name
  container_port = local.api_container_port
  environment    = var.environment
  vpc_id         = module.vpc.id
}

module "api_secrets" {
  source      = "./secrets"
  name        = local.api_name
  environment = var.environment
  secrets     = var.api_secrets
}
