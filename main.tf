# Read Current Session Details
data "azuread_client_config" "current" {}

# Read Azure Native Applications
data "azuread_application_published_app_ids" "well_known" {}
data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}

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

  required_resource_access {
    resource_app_id = data.azuread_service_principal.msgraph.client_id

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Application.Read.All"]
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "workspace" {
  client_id = azuread_application.workspace.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# Grant Admin Privileges for Azure Secrets Engine SPN
resource "azuread_app_role_assignment" "workspace" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["Application.Read.All"]
  principal_object_id = azuread_service_principal.workspace.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
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

resource "tfe_variable" "arm_tenant_id" {
  key          = "ARM_TENANT_ID"
  value        = var.tenant_id
  category     = "env"
  description  = "azure tenant id"
  workspace_id = tfe_workspace.this.id
}

resource "github_repository" "workspace" {
  name        = var.workspace_label

  visibility = "private"

  template {
    owner                = "kevin-loehfelm"
    repository           = "template-demo-workspace"
    include_all_branches = true
  }
}