# micro-service-00/kms/terragrunt.hcl

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:ss0x44/tf-modules.git//v${local.tf_version}/aws_modules/sqs"
}

inputs = {
 sqs_queues = [
  {
    name               = "queue"
    delay_seconds      = 0
    max_message_size   = 262144
    message_retention  = 86400
    visibility_timeout = 30
    receive_wait_time  = 0
  },
  {
    name               = "queue"
    delay_seconds      = 5
    max_message_size   = 128000
    message_retention  = 345600
    visibility_timeout = 45
    receive_wait_time  = 10
  }
]

}
