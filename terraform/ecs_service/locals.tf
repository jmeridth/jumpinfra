locals {
  app_container_definitions = [{
    name        = local.container_name
    image       = "${var.container_image}:latest"
    essential   = true
    environment = local.container_env_vars
    memory      = var.container_memory
    cpu         = var.container_cpu
    linuxParameters = {
      initProcessEnabled = true
    }
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    logConfiguration = {
      logDriver = "json-file"
    }
    secrets = var.container_secrets
  }]
  container_env_vars = [for k, v in var.container_env_vars : {
    name  = k
    value = v
  }]
  container_name = "${var.name}-container-${var.environment}"
  logging_container_definitions = [{
    name        = local.container_name
    image       = "${var.container_image}:latest"
    essential   = true
    environment = local.container_env_vars
    memory      = var.container_memory
    cpu         = var.container_cpu
    command     = ["syslog+tls://logs3.papertrailapp.com:37939"]
    mountPoints = [
      {
        sourceVolume  = local.logging_volume_name
        containerPath = local.logging_path
      }
    ]
  }]
  logging_path        = "/var/run/docker.sock"
  logging_volume_name = "logger"
}
