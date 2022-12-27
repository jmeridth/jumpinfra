include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/lb")}///"
}

dependency "api_certificate" {
  config_path = find_in_parent_folders("api/certificate")
  mock_outputs = {
    arn = "arn:aws:*:us-west-2:aws:placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "api_target_group" {
  config_path = find_in_parent_folders("api/target_group")
  mock_outputs = {
    arn = "arn:aws:*:us-west-2:aws:placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "web_target_group" {
  config_path = find_in_parent_folders("web/target_group")
  mock_outputs = {
    arn = "arn:aws:*:us-west-2:aws:placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "web_certificate" {
  config_path = find_in_parent_folders("web/certificate")
  mock_outputs = {
    arn = "arn:aws:*:us-west-2:aws:placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    id             = "placeholder"
    public_subnets = [{ "id" : "placeholder" }]
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  api_certificate_arn = dependency.api_certificate.outputs.arn
  listener_rules = [
    {
      host_headers     = ["api.staging2.jump.co"]
      name             = "api"
      priority         = 100
      target_group_arn = dependency.api_target_group.outputs.arn
    },
    {
      host_headers     = ["staging2.jump.co"]
      name             = "web"
      priority         = 300
      target_group_arn = dependency.web_target_group.outputs.arn
    },
  ]
  path_patterns_listener_rules = [
    {
      host_headers     = ["api.staging2.jump.co"]
      name             = "api_health"
      path_patterns    = ["/health"]
      priority         = 200
      target_group_arn = dependency.api_target_group.outputs.arn
    },
  ]
  public_subnets       = dependency.vpc.outputs.public_subnets
  web_certificate_arn  = dependency.web_certificate.outputs.arn
  web_target_group_arn = dependency.web_target_group.outputs.arn
  vpc_id               = dependency.vpc.outputs.id
}
