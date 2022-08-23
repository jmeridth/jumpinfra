include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/ecs_cluster")}///"
}

dependency "iam" {
  config_path = find_in_parent_folders("iam")
  mock_outputs = {
    ecs_task_encrypt_json = "placeholder"
  }
  skip_outputs = true
}

inputs = {
  ecs_task_encrypt_json = dependency.iam.outputs.ecs_task_encrypt_json
}
