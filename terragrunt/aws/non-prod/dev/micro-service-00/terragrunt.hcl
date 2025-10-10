# micro-service-00/terragrunt.hcl
include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals {
  app_id        = include.root.locals.app_id
  app_prefix    = include.root.locals.app_prefix
  global_tags   = include.root.locals.global_tags 
  env_short     = include.root.locals.environment
  account_type  = include.root.locals.account_type
  account_id    = include.root.locals.account_id
  region        = include.root.locals.region
  region_short  = include.root.locals.region_short
  deploy_color  = include.root.locals.deploy_color
  tf_version    = include.root.locals.tf_version
  tg_version    = include.root.locals.tg_version
  mvn_version   = include.root.locals.mvn_version
  java_version  = include.root.locals.java_version
}

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
