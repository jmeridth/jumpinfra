include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/certificate")}///"
}

dependency "route53" {
  config_path = find_in_parent_folders("route53")
  mock_outputs = {
    fqdn = "placeholder"
  }
  skip_outputs = true
}

inputs = {
  domain_name         = "api.staging2.jump.co"
  route53_record_fqdn = dependency.route53.outputs.fqdn
  verification_method = "DNS"
}
