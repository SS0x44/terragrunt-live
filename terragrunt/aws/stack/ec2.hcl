locals {
  # Dynamically construct the module source URL using TF_VERSION
  base_source_url = "git::git@github.com:ss0x44/tf-modules.git//v${get_env("TF_VERSION")}/aws_modules/ec2"
  # Expose shared inputs from the calling terragrunt.hcl
  account_type  = include.service.inputs.account_type
  account_id    = include.service.inputs.account_id
  region        = include.service.inputs.region
  environment   = include.service.inputs.environment
  deploy_color  = include.service.inputs.deploy_color
}
