terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.53.1" # Jul 19 2024
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.2.3" # Jul 19 2024
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.57.0" # Jul 19 2024
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.3.0" # Jul 19 2024
    }
  }
}
