# micro-service-00/terragrunt.hcl
include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include {
  path = find_in_parent_folders()
}

locals {
  app_id        = include.root.locals.app_id
  app_prefix    = include.root.locals.app_prefix
  global_tags   = include.root.locals.global_tags 
  # Load shared configuration values from pipeline .gitlab-ci.yml file variables sections
  account_type   = get_env("ACCOUNT_TYPE")
  account_id     = get_env("ACCOUNT_ID") 
  region         = get_env("REGION")
  region_short   = get_env("REGION_SHORT")
  env_short      = get_env("ENVIRONMENT")
  deploy_color   = get_env("DEPLOY_STRATERGY")
  tf_version     = get_env("TERRAFORM_VERSION")
  tg_version    = get_env("TERRAGRUNT_VERSION")
  mvn_version   = get_env("MVN_VERSION")
  java_version  = get_env("JAVA_VERSION")
}

terraform {
  extra_arguments "common_vars" {
    commands = ["apply", "plan", "destroy"]
    arguments = [
      "-var", "environment=${get_env("ENVIRONMENT")}"
    ]
  }
}
