# Provider(s): AzureAD Provider
provider "azuread" {
  use_cli                 = false
  use_oidc                = true
  client_id_file_path     = var.tfc_vault_backed_azure_dynamic_credentials.default.client_id_file_path
  client_secret_file_path = var.tfc_vault_backed_azure_dynamic_credentials.default.client_secret_file_path
  tenant_id               = var.azure_tenant_id
}

# Provider(s): GitHub Provider
provider "github" {
  token = data.vault_kv_secret_v2.github.data["token"]
}

# Provider(s): HCP Terraform/Terraform Enterprise Provider
provider "tfe" {
  token = data.vault_kv_secret_v2.terraform.data["token"]
  # TODO: token = data.vault_generic_secret.terraform.data["token"]
}