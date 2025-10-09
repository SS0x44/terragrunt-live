include "root" {
  path   = "${find_in_parent_folders("root.hcl")}"
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
}
terraform {
  source = "git::git@github.com:ss0x44/tf-modules.git//v${locals.tf_version}/aws_modules/vpc"
}