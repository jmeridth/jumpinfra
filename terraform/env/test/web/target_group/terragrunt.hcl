include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/target_group")}///"
}

dependency "lb" {
  config_path = find_in_parent_folders("lb")
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

inputs = {
  container_port                            = 3001
  lb_listener_https_arn                     = dependency.lb.outputs.aws_lb_listener_https_arn
  listener_rule_host_header_endpoint_domain = "api.test.jump.co"
  listener_rule_host_header_health_domain   = "api.test.jump.co"
  vpc_id                                    = dependency.vpc.outputs.id
}
