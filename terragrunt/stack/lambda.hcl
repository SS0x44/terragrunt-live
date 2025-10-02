include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "stack" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/stack/lambda.hcl"
  expose = true
}

terraform {
  source = "${include.stack.locals.base_source_url}?ref=main"
}
