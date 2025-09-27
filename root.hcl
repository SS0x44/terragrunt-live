locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl")).locals
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  env_vars         = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  namespace_vars   = read_terragrunt_config(find_in_parent_folders("namespace.hcl")).locals

  account_type = local.account_vars.account_type
  account_id   = local.account_vars.aws_account_id
  region_short = local.region_vars.region_short
  region       = local.region_vars.region
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.app_id}-${local.app_prifix}-${local.account_type}-terragrunt-tfstate${local.aws_region_short}"
    key            = "${path_relative_to_include()}/terrfrom.tfstate"
    region         = local.region
    use_lockfiles  = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.env_vars.locals,
  locals.namespace.locals,
)
