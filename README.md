# HCP Vault and Boundary demo

Demo environment overview

<img alt="overview" src="https://github.com/itot555/ext-zts-vault-boundary-demo/blob/main/images/pic-hcp-vault-boundary-demo-overview.png">

## Prerequisites

- Terraform Cloud
- HCP Vault
- HCP Boundary
- Auth0

# Demo Step

1. Provisioning HCP Vault and Boundary cluster (ex. Terraform Cloud workspace: `zts-demo_hcp`) -> `hcp` directory
1. Provisioning AWS resources (ex. Terraform Cloud workspace: `zts-demo_aws`) -> `aws` directory
1. Configure HCP Vault (ex. Terraform Cloud workspace: `zts-demo_vault`) -> `vault` directory
1. Configure HCP Boundary (ex. Terraform Cloud workspace: `zts-demo_boundary`) -> `boundary` directory