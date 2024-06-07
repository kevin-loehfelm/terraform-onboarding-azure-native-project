data "tfe_organization" "this" {
  name = var.terraform_organization
}

data "tfe_project" "this" {
  organization = data.tfe_organization.this.name
  name         = var.terraform_project
}

resource "tfe_workspace" "this" {
  name         = "tfe-workspace-${var.workspace_label}"
  organization = data.tfe_organization.this.name
  project_id   = data.tfe_project.this.id
  tag_names = [
    "azure"
  ]
}

resource "azuread_application" "workspace" {
  display_name = tfe_workspace.this.name
  description  = "Service Principal for TFE Workspace: ${tfe_workspace.this.name}"
}

resource "azuread_application_federated_identity_credential" "plan" {
  application_id = azuread_application.workspace.id
  display_name   = "${tfe_workspace.this.name}-plan"
  description    = "Federated Identity: ${tfe_workspace.this.name} PLAN"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://app.terraform.io"
  subject        = "organization:${data.tfe_organization.this.name}:project:${data.tfe_project.this.name}:workspace:${tfe_workspace.this.name}:run_phase:plan"
}

resource "azuread_application_federated_identity_credential" "apply" {
  application_id = azuread_application.workspace.id
  display_name   = "${tfe_workspace.this.name}-apply"
  description    = "Federated Identity: ${tfe_workspace.this.name} APPLY"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://app.terraform.io"
  subject        = "organization:${data.tfe_organization.this.name}:project:${data.tfe_project.this.name}:workspace:${tfe_workspace.this.name}:run_phase:apply"
}

resource "tfe_variable" "tfc_azure_provider_auth" {
  key          = "TFC_AZURE_PROVIDER_AUTH"
  value        = true
  category     = "env"
  description  = "enable azure dynamic credentials"
  workspace_id = tfe_workspace.this.id
}

resource "tfe_variable" "tfc_azure_run_client_id" {
  key          = "TFC_AZURE_RUN_CLIENT_ID"
  value        = azuread_application.workspace.client_id
  category     = "env"
  description  = "azure dynamic credentials client id"
  workspace_id = tfe_workspace.this.id
}


