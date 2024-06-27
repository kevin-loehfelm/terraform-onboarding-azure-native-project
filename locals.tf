# Environment Details
locals {
  workspaces = {
    prod  = "prod-${var.project_name}"
    dev   = "dev-${var.project_name}"
    stage = "stage-${var.project_name}"
  }
}