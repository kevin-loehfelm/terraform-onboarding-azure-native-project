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

variable "prefix" {
  type        = string
  description = "environment prefix"
  default     = "demo"
}

variable "azure_tenant_id" {
  type        = string
  description = "azure tenant id"
  default     = "27113040-bd29-4848-a781-1d9d70bcf768"
}

variable "terraform_organization" {
  type        = string
  description = "hcp terraform organization"
  default     = "kloehfelm-demo"
}

variable "project_name" {
  type = string
}