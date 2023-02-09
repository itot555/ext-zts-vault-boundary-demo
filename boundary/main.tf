data "terraform_remote_state" "hcp" {

  backend = "remote"

  config = {
    organization = "${var.tfc_organization}"
    workspaces = {
      name = "zts-demo_hcp" # changeme
    }
  }
}

data "terraform_remote_state" "vault" {

  backend = "remote"

  config = {
    organization = "${var.tfc_organization}"
    workspaces = {
      name = "zts-demo_vault" # changeme
    }
  }
}

data "terraform_remote_state" "aws" {

  backend = "remote"

  config = {
    organization = "${var.tfc_organization}"
    workspaces = {
      name = "zts-demo_aws" # changeme
    }
  }
}

# HPC Boundary
provider "boundary" {
  addr                            = data.terraform_remote_state.hcp.outputs.boundary_cluster_url
  auth_method_id                  = var.auth_method_id            # changeme
  password_auth_method_login_name = var.boundary_cluster_username # changeme
  password_auth_method_password   = var.boundary_cluster_password # changeme
}

provider "auth0" {}

data "auth0_client" "hcp_boundary" {
  name = "HCP Boundary" # changeme
}