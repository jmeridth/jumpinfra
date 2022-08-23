include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/db")}///"
}

dependency "security_group" {
  config_path = find_in_parent_folders("api/security_group")
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

locals {
  env_vars = yamldecode(file("${find_in_parent_folders("api.envvars.test.yaml", "stack.yaml")}"))
  secrets  = yamldecode(file("${find_in_parent_folders("api.secrets.test.yaml", "stack.yaml")}"))
}

inputs = {
  engine            = local.env_vars.api_env_vars["TYPEORM_CONNECTION"]
  engine_version    = local.env_vars.api_env_vars["DB_ENGINE_VERSION"]
  instance_class    = local.env_vars.api_env_vars["DB_INSTANCE_CLASS"]
  password          = local.secrets.api_secrets["TYPEORM_PASSWORD"]
  port              = local.env_vars.api_env_vars["TYPEORM_PORT"]
  private_subnets   = dependency.vpc.outputs.private_subnets
  security_group_id = dependency.security_group.outputs.id
  username          = local.secrets.api_secrets["TYPEORM_USERNAME"]
  vpc_id            = dependency.vpc.outputs.id
}
