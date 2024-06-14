terraform {

  cloud {
    organization = "kloehfelm-demo"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io
    workspaces {
      project = "terraform-onboarding"
      name    = "test-demo-project"
    }
  }

  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    tfe = {
      source = "hashicorp/tfe"
    }
    github = {
      source = "integrations/github"
    }
  }
}
