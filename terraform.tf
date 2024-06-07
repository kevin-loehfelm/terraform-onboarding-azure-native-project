terraform {

  cloud {
    organization = "kloehfelm-demo"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io
    workspaces {
      project = "tfe-onboarding"
      name    = "module-test"
    }
  }

  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    tfe = {
      source = "hashicorp/tfe"
    }
  }
}