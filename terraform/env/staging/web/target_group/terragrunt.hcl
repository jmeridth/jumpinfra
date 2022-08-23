include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/target_group")}///"
}

locals {
  domain = "api.staging2.jump.co"
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    id = "placeholder"
  }
  skip_outputs = true
}

inputs = {
  container_port = "3000"
  vpc_id         = dependency.vpc.outputs.id
}
