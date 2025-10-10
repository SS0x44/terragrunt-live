# micro-service-00/ec2/terragrunt.hcl

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:ss0x44/tf-modules.git//v${local.tf_version}/aws_modules/ec2"
}

inputs = {
  account_id               = local.account_id
  app_user                 = get_env("APP_USER")

  vpc_zone_identifiner     = "<placeholder-vpc-identifier>"
  vpc_name_tag             = "<placeholder-name-tag>"
  vpc_environmet_tag       = "<placeholder-env-tag>"
  pipeline_role            = "<placeholder-role>"

  ec2_name                 = "${local.app_id}-${local.app_prefix}-${local.env_short}-${local.region_short}"
  ec2_profile              = "${local.app_id}-${local.app_prefix}-${local.env_short}-${local.region_short}"
  security_group           = "${local.app_id}-${local.app_prefix}-${local.env_short}-${local.region_short}"
  launch_template          = "${local.app_id}-${local.app_prefix}-${local.env_short}-${local.region_short}"
  autoscale_group          = "${local.app_id}-${local.app_prefix}-${local.env_short}-${local.region_short}"

  ami_name                 = "<placeholder-goldenimage-pattern>"
  instance_type            = "<placeholder-compute-type>"
  health_check_internal    = 300
  health_check_type        = "EC2"
  max_size                 = 1
  min_size                 = 1
  desired_capacity         = 1

  usr_data_tpl_path        = templatefile("${path.module}/template/config.sh.tpl")

  ebs_optimized            = true
  ebs_device_name          = "/dev/xvda"
  ebs_launch_tpl           = {
    volume_size            = 100
    volume_type            = "gp2"
  }

  launch_tpl_imdsv2        = {
    http_endpoint               = "enabled"
    http_enabled                = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  tags = merge(local.global_tags, {
    Name        = "${local.app_id}-${local.app_prefix}-${local.deploy_color}-${local.region_short}"
    Environment = "Development"
  })
}
