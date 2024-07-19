<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
# Azure Federated Identity

This module deploy resources to support VCS-driven Azure Infrastructure Automation using dynamic credentials. Dynamic credentials are delivered directly by Azure to HCP Terraform.

## GitHub

| Resource Type | Resource | Description |
|---------------|----------|-------------|
| GitHub Repo | project-\<project_name> | GitHub private repository |
| GitHub Repo Branch | project-\<project_name>/main | VCS branch for tracking code intended for the Production environment |
| GitHub Repo Branch | project-\<project_name>/stage | VCS branch for tracking code intended for the Staging environment |
| GitHub Repo Branch | project-\<project_name>/dev | VCS branch for tracking code intended for the Devlopment environment |

## HCP Terraform

| Resource Type | Resource | Description |
|---------------|----------|-------------|
| Terrform Workspace | project-\<project_name>-prod | Terraform workspace tracking infrastructure automation for the Production environment. Configured with VCS-connectivity to the main branch  |
| Terrform Workspace | project-\<project_name>-stage | Terraform workspace tracking infrastructure automation for the Staging environment. Configured with VCS-connectivity to the stage branch  |
| Terrform Workspace | project-\<project_name>-dev | Terraform workspace tracking infrastructure automation for the Development environment. Configured with VCS-connectivity to the dev branch  |

## Azure

| Resource Type | Resource | Description |
|---------------|----------|-------------|
| Azure Service Prinicipal | project-\<project_name>-prod | Azure Service Prinicipal for access to the Azure Production environment |
| Azure Service Prinicipal | project-\<project_name>-stage | Azure Service Prinicipal for access to the Azure Staging environment |
| Azure Service Prinicipal | project-\<project_name>-dev | Azure Service Prinicipal for access to the Azure Development environment |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.53.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 6.2.3 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.57.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.3.0 |

## Resources

| Name | Type |
|------|------|
| [azuread_app_role_assignment.read_all](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_federated_identity_credential.apply](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) | resource |
| [azuread_application_federated_identity_credential.plan](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [github_branch.dev](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch) | resource |
| [github_branch.stage](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_file.configuration](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.readme](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [tfe_variable.arm_tenant_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_azure_provider_auth](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_azure_run_client_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_workspace.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [tfe_oauth_client.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/oauth_client) | data source |
| [tfe_organization.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/organization) | data source |
| [tfe_project.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/project) | data source |
| [vault_kv_secret_v2.github](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/kv_secret_v2) | data source |
| [vault_kv_secret_v2.terraform](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/kv_secret_v2) | data source |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->