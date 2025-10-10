# micro-service-00/vpc/terragrunt.hcl

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:ss0x44/tf-modules.git//v${local.tf_version}/aws_modules/vpc"
}

inputs = {
 vpc_name            =
 vpc_cidr            =
 public_subnet_name  =
 public_subnet_cidr  = 
 public_route_name   =
 public_azs          =
 public_igw_name     =
 private_subnet_name =
 private_subnet_cidr =
 private_route_name  =
 private_azs         =
 private_ngw_name    = 
  

}
