# Provisioning HCP Vault and Boundary cluster

# Prerequisites

- Create Terraform Cloud (TFC) workspaces for Vault and Boundary resources (ex. workspace's name: `zts-demo_vault`, `zts-demo_boundary`)
- Set HCP provider and TFE provider credentials on this TFC workspace (ex. workspaces'name: `zts-demo_hcp`)

# References

- [hcp_boundary_cluster (Resource)](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/boundary_cluster)
- [Resource (hcp_hvn)](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn)
- [Resource (hcp_vault_cluster_admin_token)](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster_admin_token)
- [Resource (hcp_vault_cluster)](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster)