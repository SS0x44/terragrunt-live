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
  tg_version    = include.root.locals.tg_version
  mvn_version   = include.root.locals.mvn_version
  java_version  =  include.root.locals.java_version
}
terraform {
  source = "git::git@github.com:ss0x44/tf-modules.git//v${locals.tf_version}/aws_modules/ec2"
}

inputs = {
  instance_type = "t3.micro"
  ami_id        = "ami-1234567890abcdef0"
   user_data    = base64encode(templatefile("${path.module}/template/config.sh.tpl", {
    TERRAFORM_VERSION  = locals.tf_version
    TERRAGRUNT_VERSION = locals.tg_version
    JAVA_VERSION       = locals.java_version
    MVN_VERSION        = locals.mvn_version
    REGION             = locals.region
  })

  tags = merge("${locals.global_tags}", {
    Name        =  "${locals.app_id}-${locals.app_prefix}-${locals.deploy_color}-${locals.region_short}"
    Environment =  "Development"
  }
}
