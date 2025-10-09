include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "stack" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/stack/ec2.hcl"
  expose = true
}

terraform {
  source = "${include.stack.locals.base_source_url}?ref=main"
}

inputs = {
 # Load shared configuration values from pipeline .gitlab-ci.yml file variables sections
  account_type   = get_env("ACCOUNT_TYPE")
  account_id     = get_env("ACCOUNT_ID") 
  region         = get_env("REGION")
  environment    = get_env("ENVIRONMENT")
  deploy_color   = get_env("DEPLOY_STRATERGY")
}
