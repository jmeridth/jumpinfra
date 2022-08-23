include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/lb")}///"
}

dependency "api_certificate" {
  config_path = find_in_parent_folders("api/certificate")
  mock_outputs = {
    arn = "placeholder"
  }
  skip_outputs = true
}

dependency "api_target_group" {
  config_path = find_in_parent_folders("api/target_group")
  mock_outputs = {
    arn = "placeholder"
  }
  skip_outputs = true
}

dependency "web_target_group" {
  config_path = find_in_parent_folders("web/target_group")
  mock_outputs = {
    arn = "placeholder"
  }
  skip_outputs = true
}

dependency "web_certificate" {
  config_path = find_in_parent_folders("web/certificate")
  mock_outputs = {
    arn = "placeholder"
  }
  skip_outputs = true
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    public_subnets = "placeholder"
  }
  skip_outputs = true
}

inputs = {
  api_certificate_arn = dependency.api_certificate.outputs.arn
  listener_rules = [
    {
      host_header      = ["api.staging2.jump.co"]
      priority         = 100
      path_pattern     = []
      target_group_arn = dependency.api_target_group.outputs.arn
    },
    {
      host_header      = ["api.staging2.jump.co"]
      priority         = 200
      path_pattern     = ["/health"]
      target_group_arn = dependency.api_target_group.outputs.arn
    },
    {
      host_header      = ["staging2.jump.co"]
      path_pattern     = []
      priority         = 300
      target_group_arn = dependency.web_target_group.outputs.arn
    },
  ]
  public_subnets       = dependency.vpc.outputs.public_subnets
  web_certificate_arn  = dependency.web_certificate.outputs.arn
  web_target_group_arn = dependency.web_target_group.outputs.arn
}
