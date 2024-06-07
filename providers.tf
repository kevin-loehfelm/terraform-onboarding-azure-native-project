provider "azuread" {
  use_cli                 = false
  use_oidc                = true
  client_id_file_path     = var.tfc_vault_backed_azure_dynamic_credentials.default.client_id_file_path
  client_secret_file_path = var.tfc_vault_backed_azure_dynamic_credentials.default.client_secret_file_path
  tenant_id               = "27113040-bd29-4848-a781-1d9d70bcf768"
}