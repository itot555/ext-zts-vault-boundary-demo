variable "hvn_id" {
  description = "The ID of the HCP HVN."
  type        = string
}

variable "cloud_provider" {
  description = "The cloud provider of the HCP HVN and Vault cluster."
  type        = string
  default     = "aws"
}

variable "hcp_region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
  default     = "ap-southeast-1"
}

variable "vault_cluster_id" {
  description = "The ID of the HCP Vault cluster."
  type        = string
}

variable "hcp_vault_tier" {
  description = "HCP Vault tier"
  type        = string
  default     = "dev"
}

variable "boundary_cluster_id" {
  description = "The ID of the Boundary cluster."
  type        = string
}

variable "boundary_cluster_username" {
  description = "The username of the initial admin user. This must be at least 3 characters in length, alphanumeric, hyphen, or period."
  type        = string
  default     = "admin"
}

variable "boundary_cluster_password" {
  description = "The password of the initial admin user. This must be at least 8 characters in length. Note that this may show up in logs, and it will be stored in the state file."
  type        = string
  default     = "password"
  sensitive   = true
}

variable "tfc_organization" {}