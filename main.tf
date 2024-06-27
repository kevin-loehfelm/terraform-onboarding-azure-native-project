# Data Source(s): Retrieve GitHub token from Vault KVv2 secrets engine (static)
data "vault_kv_secret_v2" "github" {
  mount = "static" #TODO
  name  = "github" #TODO
}
# Data Source(s): Retrieve Terraform token from Vault KVv2 secrets engine (static)
# TODO: This is a workaround due to permission issues with dynamic credentials
data "vault_kv_secret_v2" "terraform" {
  mount = "static"    #TODO
  name  = "terraform" #TODO
}

/*
# Data Source(s): Retrieve HCP Terraform token from Vault TFC secrets engine (dynamic)
data "vault_generic_secret" "terraform" {
  path = "terraform/creds/terraform_project_onboarding" #TODO
}
*/

/**********************
GitHub
**********************/

# Resource(s): GitHub Repo
resource "github_repository" "this" {
  name = "project-${var.project_name}"

  visibility = "private"

  template {
    owner      = "kevin-loehfelm"
    repository = "template-demo-project"
  }
}

# Resource(s): GitHub Repo initial configuration: terraform.tf
resource "github_repository_file" "configuration" {
  repository = github_repository.this.name
  branch     = "main"
  file       = "terraform.tf"
  content = templatefile("${path.module}/github_terraform_tf.tftpl",
    {
      terraform_organization : data.tfe_organization.this.name,
      #terraform_project   = data.tfe_project.this.name,
      project_name = var.project_name
    }
  )
  commit_message      = "Configuration: terraform.tf"
  commit_author       = "TFE Onboarding"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

# Resource(s): GitHub Repo initial configuration: README.md
resource "github_repository_file" "readme" {
  repository = github_repository.this.name
  file       = "README.md"
  content = templatefile("${path.module}/github_readme_md.tftpl",
    {
      project_name = var.project_name
      hcptf_org : data.tfe_organization.this.name
      prod_project    = data.tfe_project.this["prod"].name
      prod_workspace  = local.workspaces.prod
      dev_project     = data.tfe_project.this["dev"].name
      dev_workspace   = local.workspaces.dev
      stage_project   = data.tfe_project.this["stage"].name
      stage_workspace = local.workspaces.stage
      repo_name       = github_repository.this.full_name
      repo_clone_http = github_repository.this.http_clone_url
      repo_clone_ssh  = github_repository.this.ssh_clone_url
    }
  )
  commit_message      = "Configuration: README.md"
  commit_author       = "TFE Onboarding"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_branch" "stage" {
  depends_on = [
    github_repository_file.configuration,
    github_repository_file.readme
  ]
  repository = github_repository.this.name
  branch     = "stage"
}

resource "github_branch" "dev" {
  depends_on = [
    github_repository_file.configuration,
    github_repository_file.readme
  ]
  repository = github_repository.this.name
  branch     = "dev"
}

/**********************
Microsoft Azure
**********************/

# Data Source(s): Current Session Details
data "azuread_client_config" "current" {}

# Data Source(s): Azure Native Applications, MSGraph
data "azuread_application_published_app_ids" "well_known" {}
data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}

# Resource(s): Azure Application for Terraform Workload Identity
resource "azuread_application" "this" {
  for_each     = local.workspaces
  display_name = "project-${each.key}-${var.project_name}"
  description  = "Service Principal for Terraform Workload Identity"

  required_resource_access {
    resource_app_id = data.azuread_service_principal.msgraph.client_id

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Application.Read.All"]
      type = "Role"
    }
  }
}

# Resource(s): Azure Service Principal for Terraform Workload Identity
resource "azuread_service_principal" "this" {
  for_each  = local.workspaces
  client_id = azuread_application.this[each.key].client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# Resource(s): Grant Admin Privileges for Application.Read.All Service Principal permission
resource "azuread_app_role_assignment" "read_all" {
  for_each            = local.workspaces
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["Application.Read.All"]
  principal_object_id = azuread_service_principal.this[each.key].object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

# Resource(s): Federated Identity for workspace PLAN operations
resource "azuread_application_federated_identity_credential" "plan" {
  for_each       = local.workspaces
  application_id = azuread_application.this[each.key].id
  display_name   = "${each.key}-${var.project_name}-plan"
  description    = "Federated Identity: ${tfe_workspace.this[each.key].name} PLAN"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://app.terraform.io"
  subject        = "organization:${data.tfe_organization.this.name}:project:${data.tfe_project.this[each.key].name}:workspace:${tfe_workspace.this[each.key].name}:run_phase:plan"
}

# Resource(s): Federated Identity for workspace APPLY operations
resource "azuread_application_federated_identity_credential" "apply" {
  for_each       = local.workspaces
  application_id = azuread_application.this[each.key].id
  display_name   = "${each.key}-${var.project_name}-apply"
  description    = "Federated Identity: ${tfe_workspace.this[each.key].name} APPLY"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://app.terraform.io"
  subject        = "organization:${data.tfe_organization.this.name}:project:${data.tfe_project.this[each.key].name}:workspace:${tfe_workspace.this[each.key].name}:run_phase:apply"
}

/**********************
HCP Terraform
**********************/

# Data Source(s): Terraform Organization
data "tfe_organization" "this" {
  name = var.terraform_organization
}

# Data Source(s): Terraform Project(s)
data "tfe_project" "this" {
  for_each     = local.workspaces
  organization = data.tfe_organization.this.name
  name         = "${var.prefix}-${each.key}"
}

# Data Source(s): Terraform OAuth for GitHub
data "tfe_oauth_client" "this" {
  organization     = data.tfe_organization.this.name
  service_provider = "github"
}

# Resource(s): Terraform Workspace(s)
resource "tfe_workspace" "this" {
  for_each       = local.workspaces
  name           = each.value
  organization   = data.tfe_organization.this.name
  project_id     = data.tfe_project.this[each.key].id
  queue_all_runs = false
  tag_names = [
    "platform:azure",
    "env:${each.key}",
    "project:${var.project_name}"
  ]
  vcs_repo {
    branch         = each.key == "prod" ? "main" : each.key
    identifier     = github_repository.this.full_name
    oauth_token_id = data.tfe_oauth_client.this.oauth_token_id
  }
  depends_on = [
    github_repository.this,
    github_branch.stage,
    github_branch.dev
  ]
}

# Resource(s): Terraform Workspace Variable TFC_AZURE_PROVIDER_AUTH
resource "tfe_variable" "tfc_azure_provider_auth" {
  for_each     = local.workspaces
  key          = "TFC_AZURE_PROVIDER_AUTH"
  value        = true
  category     = "env"
  description  = "enable azure dynamic credentials"
  workspace_id = tfe_workspace.this[each.key].id
}

# Resource(s): Terraform Workspace Variable TFC_AZURE_RUN_CLIENT_ID
resource "tfe_variable" "tfc_azure_run_client_id" {
  for_each     = local.workspaces
  key          = "TFC_AZURE_RUN_CLIENT_ID"
  value        = azuread_application.this[each.key].client_id
  category     = "env"
  description  = "azure dynamic credentials client id"
  workspace_id = tfe_workspace.this[each.key].id
}

# Resource(s): Terraform Workspace Variable ARM_TENANT_ID
resource "tfe_variable" "arm_tenant_id" {
  for_each     = local.workspaces
  key          = "ARM_TENANT_ID"
  value        = var.azure_tenant_id
  category     = "env"
  description  = "azure tenant id"
  workspace_id = tfe_workspace.this[each.key].id
}