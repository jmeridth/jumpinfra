include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/certificate")}///"
}

inputs = {
  domain_name         = "staging2.jump.co"
  verification_method = "DNS"
}
