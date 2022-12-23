include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/route53")}///"
}

dependency "lb" {
  config_path = find_in_parent_folders("lb")
  mock_outputs = {
    dns_name = "placeholder"
    zone_id  = "placeholder"
  }
  skip_outputs = true
}

inputs = {
  record_name = "api.staging2.jump.co"
  lb_dns_name = dependency.lb.outputs.dns_name
  lb_zone_id  = dependency.lb.outputs.zone_id
}
