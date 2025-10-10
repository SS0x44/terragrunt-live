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

  vpc_zone_identifiner     = "<placeholder-vpc-identifier>"
  vpc_name_tag             = "<placeholder-name-tag>"
  vpc_environmet_tag       = "<placeholder-env-tag>"
  pipeline_deployment_role = "<placeholder-role>"

  ec2_name                 = "${locals.app_id}-${locals.app_prefix}-${locals.env_short}-${locals.region_short}"
  ec2_profile              = "${locals.app_id}-${locals.app_prefix}-${locals.env_short}-${locals.region_short}"
  security_group           = "${locals.app_id}-${locals.app_prefix}-${locals.env_short}-${locals.region_short}"
  launch_template          = "${locals.app_id}-${locals.app_prefix}-${locals.env_short}-${locals.region_short}"
  autoscale_group          = "${locals.app_id}-${locals.app_prefix}-${locals.env_short}-${locals.region_short}"
  
  ami_name                  = "<placeholder-goldenimage-pattern>"
  instance_type             = "<placeholder-compute-type>"
  health_check_internal     = 300
  health_check_type         = "EC2"
  max_size                  =  1
  min_size                  =  1
  desired_capacity          =  1
  
  usr_data_tpl_path         = base64encode(templatefile("${path.module}/template/config.sh.tpl", {
    TERRAFORM_VERSION       = locals.tf_version
    TERRAGRUNT_VERSION      = locals.tg_version
    JAVA_VERSION            = locals.java_version
    MVN_VERSION             = locals.mvn_version
    REGION                  = locals.region
    #add all paramter which you want to pass to userdata script in ec2 instace via cicd pipelinne gu dynamically to maintain 
    #latest version of all package install on your ec2 machine
  })
  ebs_optimized             = true
  ebs_device_name           = "/dev/xvda"
  ebs_launch_tpl            = {
    volume_size             = 100
    volume_type             = "gp2"
  }
  launch_tpl_imdsv2         = {
    http_endpoint           = "enabled"
    http_enabled            = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags  = "enbled"
  }
  tags                      = merge("${locals.global_tags}", {
    Name                    =  "${locals.app_id}-${locals.app_prefix}-${locals.deploy_color}-${locals.region_short}"
    Environment             =  "Development"
  }
}
