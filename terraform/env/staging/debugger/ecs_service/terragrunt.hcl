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
  skip_outputs = true
}

dependency "db" {
  config_path = find_in_parent_folders("db")
  mock_outputs = {
    host_address = "placeholder"
    name         = "placeholder"
  }
  skip_outputs = true
}

dependency "ecr" {
  config_path = find_in_parent_folders("ecr")
  mock_outputs = {
    aws_ecr_repository_url = "placeholder"
  }
  skip_outputs = true
}

dependency "ecs_cluster" {
  config_path = find_in_parent_folders("ecs_cluster")
  mock_outputs = {
    id   = "placeholder"
    name = "placeholder"
  }
  skip_outputs = true
}

dependency "iam" {
  config_path = find_in_parent_folders("iam")
  mock_outputs = {
    ecs_agent_name               = "placeholder"
    ecs_task_execution_role_arn  = "placeholder"
    ecs_task_execution_role_name = "placeholder"
    ecs_task_role_arn            = "placeholder"
  }
  skip_outputs = true
}

dependency "s3" {
  config_path = find_in_parent_folders("s3")
  mock_outputs = {
    bucket_name = "placeholder"
  }
  skip_outputs = true
}

dependency "secrets" {
  config_path = find_in_parent_folders("api/secrets")
  mock_outputs = {
    secrets = "placeholder"
  }
  skip_outputs = true
}

dependency "security_group" {
  config_path = find_in_parent_folders("api/security_group")
  mock_outputs = {
    id = "placeholder"
  }
  skip_outputs = true
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    private_subnets = "placeholder"
  }
  skip_outputs = true
}

locals {
  env_vars = yamldecode(file("${find_in_parent_folders("api.envvars.staging.yaml", "stack.yaml")}"))
}

inputs = {
  ami             = dependency.ami.outputs.id
  cluster_id      = dependency.ecs_cluster.outputs.id
  cluster_name    = dependency.ecs_cluster.outputs.name
  container_image = "${dependency.ecr.outputs.aws_ecr_repository_url}:latest"
  container_env_vars = merge(
    local.env_vars,
    tomap({
      "AWS_S3_BUCKET"    = dependency.s3.outputs.bucket_name
      "TYPEORM_HOST"     = dependency.db.outputs.host_address
      "TYPEORM_DATABASE" = dependency.db.outputs.name
    })
  )
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
  subnets                      = dependency.vpc.outputs.private_subnets
}
