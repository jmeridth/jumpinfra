include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/iam")}///"
}

inputs = {
  aws_region = "us-west-2"
}