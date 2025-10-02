

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "stack" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/stack/green.hcl"
  expose = true
}

terraform {
  source = "${include.stack.locals.base_source_url}?ref=v0.8.0"
}
