locals {
  # Application-specific identifiers (can be overridden per module)
  app_id         = ""
  app_prefix     = ""

  # Load shared configuration values from parent folders, with fallback to empty map if missing
  account_vars   = try(read_terragrunt_config(find_in_parent_folders("account.hcl")).locals, {})
  region_vars    = try(read_terragrunt_config(find_in_parent_folders("region.hcl")).locals, {})
  env_vars       = try(read_terragrunt_config(find_in_parent_folders("env.hcl")).locals, {})
  namespace_vars = try(read_terragrunt_config(find_in_parent_folders("namespace.hcl")).locals, {})

  # Extract specific values from loaded configs, with fallback defaults
  account_type   = try(local.account_vars.account_type, "")
  account_id     = try(local.account_vars.aws_account_id, "")
  region_short   = try(local.region_vars.region_short, "")
  region         = try(local.region_vars.region, "")
  env_short      = try(local.env_vars.env_short, "")
  env_tags       = try(local.env_vars.env_tags, {})
  namespace      = try(local.namespace_vars.namespace, "")
}

# Dynamically generate the AWS provider block with region and account restrictions
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

# Configure remote state storage in S3 for Terraform state locking and consistency
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.app_id}-${local.app_prefix}-${local.account_type}-terragrunt-tfstate${local.region_short}" # Unique bucket name per app/env/account
    key            = "${path_relative_to_include()}/terraform.tfstate" # Path-based key for modular state separation
    region         = local.region
    use_lockfiles  = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Merge all shared configuration inputs into one unified input map for Terraform modules
inputs = merge(
  local.account_vars,
  local.region_vars,
  local.env_vars,
  local.namespace_vars,
)
