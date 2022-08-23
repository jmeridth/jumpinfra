include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/certificate")}///"
}

inputs = {
  domain_name         = "jump.co"
  existing            = true
  verification_method = "DNS"
}
