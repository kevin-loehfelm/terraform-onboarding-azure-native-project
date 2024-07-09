# Environment Details
locals {
  github_owner        = element(split("/", var.github_template_repo), 0)
  template_repository = element(split("/", var.github_template_repo), 1)
  workspaces = {
    prod  = "${var.project_name}-prod"
    dev   = "${var.project_name}-dev"
    stage = "${var.project_name}-stage"
  }
}