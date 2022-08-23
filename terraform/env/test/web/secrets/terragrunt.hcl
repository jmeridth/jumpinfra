include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders("modules/secrets")}///"
}

locals {
  secrets = yamldecode(file("${find_in_parent_folders("web.secrets.test.yaml", "stack.yaml")}"))
}

inputs = {
  secret_keys   = local.secrets["web_secrets_keys"]
  secret_values = local.secrets["web_secrets"]
}
