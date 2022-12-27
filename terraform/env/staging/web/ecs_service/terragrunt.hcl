include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/ecs_service")}///"
}

dependency "ami" {
  config_path = find_in_parent_folders("ami")
  mock_outputs = {
    id = "placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "ecr" {
  config_path = find_in_parent_folders("ecr")
  mock_outputs = {
    aws_ecr_repository_url = "placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "ecs_cluster" {
  config_path = find_in_parent_folders("ecs_cluster")
  mock_outputs = {
    id   = "placeholder"
    name = "placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "iam" {
  config_path = find_in_parent_folders("iam")
  mock_outputs = {
    ecs_agent_name               = "placeholder"
    ecs_task_execution_role_arn  = "arn:aws:*:us-west-2:aws:placeholder"
    ecs_task_execution_role_name = "placeholder"
    ecs_task_role_arn            = "arn:aws:*:us-west-2:aws:placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "secrets" {
  config_path = find_in_parent_folders("secrets")
  mock_outputs = {
    secrets = [{ "name" : "placeholder", "valueFrom" : "placeholder" }]
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "security_group" {
  config_path = find_in_parent_folders("security_group")
  mock_outputs = {
    id = "placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "target_group" {
  config_path = find_in_parent_folders("target_group")
  mock_outputs = {
    arn = "arn:aws:*:us-west-2:aws:placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    id              = "placeholder"
    private_subnets = [{ "id" : "placeholder" }]
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

locals {
  env_vars = yamldecode(file("${find_in_parent_folders("web.envvars.staging.yaml", "stack.yaml")}"))
}

inputs = {
  ami                          = dependency.ami.outputs.id
  cluster_id                   = dependency.ecs_cluster.outputs.id
  cluster_name                 = dependency.ecs_cluster.outputs.name
  aws_lb_target_group_arn      = dependency.target_group.outputs.arn
  container_image              = "${dependency.ecr.outputs.aws_ecr_repository_url}:latest"
  container_env_vars           = local.env_vars["web_env_vars"]
  container_port               = 3001
  container_cpu                = 512
  container_memory             = 1024
  container_secrets            = dependency.secrets.outputs.secrets
  ecs_service_security_groups  = [dependency.security_group.outputs.id]
  ecs_task_execution_role_name = dependency.iam.outputs.ecs_task_execution_role_name
  ecs_task_execution_role_arn  = dependency.iam.outputs.ecs_task_execution_role_arn
  ecs_task_role_arn            = dependency.iam.outputs.ecs_task_role_arn
  instance_profile             = dependency.iam.outputs.ecs_agent_name
  service_desired_count        = 2
  ssm_parameter_store_prefix   = "web"
  subnets                      = dependency.vpc.outputs.private_subnets
}
