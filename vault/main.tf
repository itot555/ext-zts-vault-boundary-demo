terraform {
  required_version = ">= 0.14.9"
}

data "terraform_remote_state" "hcp" {

  backend = "remote"

  config = {
    organization = "${var.tfc_organization}"
    workspaces = {
      name = "zts-demo_hcp" # changeme
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

provider "vault" {
  token = data.terraform_remote_state.hcp.outputs.token
}