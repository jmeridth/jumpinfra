locals {
  app_container_definitions = [{
    name        = local.container_name
    image       = var.container_image
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
      logDriver = "syslog"
      options = {
        syslog-address = "tcp+tls://logs3.papertrailapp.com:37939"
        tag            = "${local.container_name}-{{.ID}}"
      }
    }
    secrets = var.container_secrets
  }]
  container_env_vars = [for k, v in var.container_env_vars : {
    name  = k
    value = v
  }]
  container_name = "${var.name}-container-${var.environment}"
}
