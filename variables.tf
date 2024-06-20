# Variable(s): Vault-backed Azure Dynamic Credentials
variable "tfc_vault_backed_azure_dynamic_credentials" {
  description = "Object containing Vault-backed Azure dynamic credentials configuration"
  type = object({
    default = object({
      client_id_file_path     = string
      client_secret_file_path = string
    })
    aliases = map(object({
      client_id_file_path     = string
      client_secret_file_path = string
    }))
  })
  default = null
}

# Variable(s): Project Name
variable "project_name" {
  type = string
}

# Variable(s): Resource Prefix (default: demo)
variable "prefix" {
  type        = string
  description = "environment prefix"
  default     = "demo"
}

# Variable(s): Azure Tenant ID (default: 27113040-bd29-4848-a781-1d9d70bcf768)
variable "azure_tenant_id" {
  type        = string
  description = "azure tenant id"
  default     = "27113040-bd29-4848-a781-1d9d70bcf768"
}

# Variable(s): HCP Terraform Organization (default: kloehfelm-demo)
variable "terraform_organization" {
  type        = string
  description = "hcp terraform organization"
  default     = "kloehfelm-demo"
}