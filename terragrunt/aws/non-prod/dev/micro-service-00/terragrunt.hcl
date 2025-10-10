# micro-service-00/terragrunt.hcl

terraform {
  extra_arguments "common_vars" {
    commands = ["apply", "plan", "destroy"]
    arguments = [
      "-var", "environment=${get_env("ENVIRONMENT")}"
    ]
  }
}

include {
  path = find_in_parent_folders()
}
