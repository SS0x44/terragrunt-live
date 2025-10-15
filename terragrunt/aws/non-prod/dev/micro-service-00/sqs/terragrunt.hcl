# micro-service-00/sqs/terragrunt.hcl

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:ss0x44/tf-modules.git//v${local.tf_version}/aws_modules/sqs"
}

inputs = {
    queue_name         = [ "${local.app_id}-${local.app_prefix}-queue02-${local.env_short}-${local.region_short}",
                          "${local.app_id}-${local.app_prefix}-queue01-${local.env_short}-${local.region_short}"
    delay_seconds      = [0,5]
    max_message_size   = [262144,128000]
    message_retention  = [86400, 345600]
    visibility_timeout = [30,45]
    receive_wait_time  = [0,10]
}
