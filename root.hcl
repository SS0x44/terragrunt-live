locals {
  app_id         = "" # to be overridden per module
  app_prefix     = ""

  account_vars   = try(read_terragrunt_config(find_in_parent_folders("account.hcl")).locals, {})
  region_vars    = try(read_terragrunt_config(find_in_parent_folders("region.hcl")).locals, {})
  env_vars       = try(read_terragrunt_config(find_in_parent_folders("env.hcl")).locals, {})
  namespace_vars = try(read_terragrunt_config(find_in_parent_folders("namespace.hcl")).locals, {})

  account_type   = try(local.account_vars.account_type, "")
  account_id     = try(local.account_vars.aws_account_id, "")
  region_short   = try(local.region_vars.region_short, "")
  region         = try(local.region_vars.region, "")
  env_short      = try(local.env_vars.env_short, "")
  env_tags       = try(local.env_vars.env_tags, {})
  namespace      = try(local.namespace_vars.namespace, "")
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region              = "${local.region}"
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.app_id}-${local.app_prefix}-${local.account_type}-terragrunt-tfstate${local.region_short}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    use_lockfiles  = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.account_vars,
  local.region_vars,
  local.env_vars,
  local.namespace_vars,
)
