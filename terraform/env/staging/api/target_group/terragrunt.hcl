include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/target_group")}///"
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    id = "placeholder"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  container_port    = "3001"
  healthy_threshold = "5"
  vpc_id            = dependency.vpc.outputs.id
}
