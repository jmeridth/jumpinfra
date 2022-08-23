include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/lb")}///"
}

dependency "api_certificate" {
  config_path = "../api/certificate"
}

dependency "web_certificate" {
  config_path = "../web/certificate"
}

inputs = {
  api_certificate_arn = dependency.api_certificate.outputs.arn
  web_certificate_arn = dependency.web_certificate.outputs.arn
}
