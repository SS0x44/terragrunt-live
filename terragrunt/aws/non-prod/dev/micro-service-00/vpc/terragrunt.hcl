# micro-service-00/vpc/terragrunt.hcl

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:ss0x44/tf-modules.git//v${local.tf_version}/aws_modules/vpc"
}

inputs = {
  vpc_name             = "${locals.app_id}-${locals.app_prefix}-${locals.env_short}-${locals.region_short}"

  vpc_cidr             = ["10.0.0.0/16"]

  public_subnet_cidr   = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidr  = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.21.0/24",
    "10.0.22.0/24"
  ]

  public_azs           = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  private_azs          = [
    "ap-south-1a",
    "ap-south-1b",
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_route_name    = "${locals.app_id}-${locals.app_prefix}-public-route-${locals.env_short}-${locals.region_short}"
  public_igw_name      = "${locals.app_id}-${locals.app_prefix}-igw-${locals.env_short}-${locals.region_short}"
  private_route_name   = "${locals.app_id}-${locals.app_prefix}-private-route-${locals.env_short}-${locals.region_short}"
  private_ngw_name     = "${locals.app_id}-${locals.app_prefix}-nategw-${locals.env_short}-${locals.region_short}"

  public_subnet_name   = [
    "${locals.app_id}-${locals.app_prefix}-public-01-${locals.env_short}-${locals.region_short}",
    "${locals.app_id}-${locals.app_prefix}-public-02-${locals.env_short}-${locals.region_short}"
  ]

  private_subnet_name  = [
    "${locals.app_id}-${locals.app_prefix}-app-01-${locals.env_short}-${locals.region_short}",
    "${locals.app_id}-${locals.app_prefix}-app-02-${locals.env_short}-${locals.region_short}",
    "${locals.app_id}-${locals.app_prefix}-db-01-${locals.env_short}-${locals.region_short}",
    "${locals.app_id}-${locals.app_prefix}-db-02-${locals.env_short}-${locals.region_short}"
  ]

  tags                 = locals.global_tags
}
