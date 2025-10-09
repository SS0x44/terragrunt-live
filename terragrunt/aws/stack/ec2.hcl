locals {
  base_source_url = "git::git@github.com:ss0x44/tf-modules.git//v${TF_VERSION}/aws_modules/ec2"
  account_type  = include.service.inputs.account_type
  account_id    = include.service.inputs.account_id
  region        = include.service.inputs.region
  environment   = include.service.inputs.environment
  deploy_color  = include.service.inputs.deploy_color
}
