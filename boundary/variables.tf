variable "auth_method_id" {
  description = "Boundary provider auth_method_id"
  default     = "ampw_1234567890"
}

variable "boundary_cluster_username" {
  description = "Boundary provider login name"
  default     = "admin"
}

variable "boundary_cluster_password" {
  description = "Boundary provider login password"
  default     = "password"
}

variable "tfc_organization" {}
variable "app_domain" {}
variable "auth0_user_id_dio" {}
variable "auth0_user_id_valentine" {}
variable "auth0_user_id_jony" {}
variable "auth0_user_id_gyro" {}
variable "auth0_user_id_blackmore" {}