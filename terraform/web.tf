module "web_ecr" {
  source      = "./ecr"
  name        = local.web_name
  environment = var.environment
}

module "web" {
  source                      = "./ecs"
  name                        = local.web_name
  environment                 = var.environment
  cluster_id                  = aws_ecs_cluster.main.id
  cluster_name                = aws_ecs_cluster.main.name
  aws_lb_target_group_arn     = module.lb_target_group.aws_lb_target_group_arn
  container_image             = "${module.web_ecr.aws_ecr_repository_url}/web-${var.environment}"
  container_env_vars          = local.web_env_vars
  container_port              = local.web_container_port
  container_cpu               = 256
  container_memory            = 512
  container_secrets           = module.web_secrets.secrets_map
  container_secrets_arn       = module.web_secrets.secrets_arn
  ecs_service_security_groups = [module.web_security_groups.ecs_tasks]
  region                      = var.aws_region
  service_desired_count       = 2
  subnets                     = module.vpc.private_subnets
}

module "web_security_groups" {
  source         = "./security_groups"
  name           = local.web_name
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = local.web_container_port
}

module "web_secrets" {
  source      = "./secrets"
  name        = local.web_name
  environment = var.environment
  secrets     = var.web_secrets
}
