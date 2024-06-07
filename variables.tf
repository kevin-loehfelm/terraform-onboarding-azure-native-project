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
}

variable "workspace_label" {
  type = string
}

variable "terraform_organization" {
  type        = string
  description = "hcp terraform organization"
  default     = "kloehfelm-demo"
}

variable "terraform_project" {
  type        = string
  description = "hcp terraform project"
  default     = "demo-prod"
}