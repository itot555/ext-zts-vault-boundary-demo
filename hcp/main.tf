# environment variables HCP_CLIENT_ID and HCP_CLIENT_SECRET set in TFC workspace as variables set.
provider "hcp" {}

# environment variables TFE_TOKEN set in TFC workspace as variables set.
provider "tfe" {}

resource "hcp_hvn" "zts" {
  hvn_id         = var.hvn_id
  cloud_provider = var.cloud_provider
  region         = var.hcp_region
  cidr_block     = "172.25.32.0/20"
}

resource "hcp_vault_cluster" "demo" {
  hvn_id          = hcp_hvn.zts.hvn_id
  cluster_id      = var.vault_cluster_id
  public_endpoint = true
  tier            = var.hcp_vault_tier
  # Valid options for tiers - dev, starter_small, standard_small, standard_medium, standard_large, plus_small, plus_medium, plus_large
}

resource "hcp_vault_cluster_admin_token" "demo" {
  cluster_id = var.vault_cluster_id
  depends_on = [
    hcp_vault_cluster.demo
  ]
}

resource "hcp_boundary_cluster" "demo" {
  cluster_id = var.boundary_cluster_id
  username   = var.boundary_cluster_username
  password   = var.boundary_cluster_password
}

# Set Vault and Boundary parameters to this workspace as env variables
data "tfe_workspace" "vault" {
  name         = "zts-demo_vault" # changeme
  organization = var.tfc_organization
}

resource "tfe_variable" "vault_address" {
  key          = "VAULT_ADDR"
  value        = hcp_vault_cluster.demo.vault_public_endpoint_url
  category     = "env"
  workspace_id = data.tfe_workspace.vault.id
  description  = "HCP Vault api endpoint"
  depends_on = [
    hcp_vault_cluster.demo,
    hcp_vault_cluster_admin_token.demo
  ]
}

resource "tfe_variable" "vault_namespace" {
  key          = "VAULT_NAMESPACE"
  value        = hcp_vault_cluster.demo.namespace
  category     = "env"
  workspace_id = data.tfe_workspace.vault.id
  description  = "HCP Vault namespace"
  depends_on = [
    hcp_vault_cluster.demo,
    hcp_vault_cluster_admin_token.demo
  ]
}

data "tfe_workspace" "boundary" {
  name         = "zts-demo_boundary" # changeme
  organization = var.tfc_organization
}

resource "tfe_variable" "boundary_address" {
  key          = "BOUNDARY_ADDR"
  value        = hcp_boundary_cluster.demo.cluster_url
  category     = "env"
  workspace_id = data.tfe_workspace.boundary.id
  description  = "HCP Boundary api endpoint"
  depends_on = [
    hcp_boundary_cluster.demo
  ]
}