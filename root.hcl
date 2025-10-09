locals {
  # Application-specific identifiers (can be overridden per module)
  app_id      = ""
  app_prefix  = ""
  global_tags = {
   app_name    = ""
   app-owner   = ""
   cloud       = ""
   managedBy   = ""
   component   = ""
   developedBy = ""
  }
  # Load shared configuration values from pipeline .gitlab-ci.yml file variables sections
  account_type   = get_env("ACCOUNT_TYPE")
  account_id     = get_env("ACCOUNT_ID") 
  region         = get_env("REGION")
  region_short   = get_env("REGION_SHORT")
  environment    = get_env("ENVIRONMENT")
  deploy_color   = get_env("DEPLOY_STRATERGY")
  tf_version     = get_env("TERRAFORM_VERSION")

# Dynamically generate the AWS provider block with region and account restrictions
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region              = get_env("REGION")
  allowed_account_ids = [get_env("ACCOUNT_ID")]
}
EOF
}

# Configure remote state storage in S3 for Terraform state locking and consistency
remote_state {
  backend = "s3"
  config = {
    encrypt       = true
    # Unique bucket name per app/env/account
    bucket        = "${local.app_id}-${local.app_prefix}-${get_env("ACCOUNT_TYPE")}-terragrunt-tfstate-${get_env("REGION_SHORT")}" 
    # Path-based key for modular state separation
    key           = "${path_relative_to_include()}/terraform.tfstate" 
    region        = get_env("REGION")
    use_lockfiles = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
