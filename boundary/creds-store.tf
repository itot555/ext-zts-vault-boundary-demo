# Create vault creadential store
resource "boundary_credential_store_vault" "hcp" {
  name        = "hcp vault credential store"
  description = "hcp vault credential store"
  namespace   = data.terraform_remote_state.hcp.outputs.namespace
  address     = data.terraform_remote_state.hcp.outputs.vault_public_endpoint_url
  token       = data.terraform_remote_state.vault.outputs.vault_client_token
  scope_id    = boundary_scope.project1.id
}

# Create credential library
resource "boundary_credential_library_vault" "linux" {
  name                = "linux vault cred library"
  description         = "credential library for linux targets"
  credential_store_id = boundary_credential_store_vault.hcp.id
  credential_type     = "ssh_private_key"
  path                = "secret/data/linux"
  http_method         = "GET"
}

resource "boundary_credential_library_vault" "postgres_ro" {
  name                = "postgres vault cred library - readonly"
  description         = "credential library for postgres targets - read only"
  credential_store_id = boundary_credential_store_vault.hcp.id
  credential_type     = "username_password"
  path                = "postgres/creds/readonly"
  http_method         = "GET"
}

resource "boundary_credential_library_vault" "postgres_rw" {
  name                = "postgres vault cred library - readwrite"
  description         = "credential library for postgres targets - read write"
  credential_store_id = boundary_credential_store_vault.hcp.id
  credential_type     = "username_password"
  path                = "postgres/creds/readwrite"
  http_method         = "GET"
}

resource "boundary_credential_library_vault" "k8s_list" {
  name                = "k8s cred library - list pod"
  description         = "credential library for k8s target - list pod"
  credential_store_id = boundary_credential_store_vault.hcp.id
  path                = "kubernetes/creds/list-pod"
  http_method         = "POST"
  http_request_body   = <<EOT
{
  "kubernetes_namespace": "default",
  "ttl": "15m"
}
EOT
}

resource "boundary_credential_library_vault" "k8s_all" {
  name                = "k8s cred library - all role"
  description         = "credential library for k8s target - all role"
  credential_store_id = boundary_credential_store_vault.hcp.id
  path                = "kubernetes/creds/all-role"
  http_method         = "POST"
  http_request_body   = <<EOT
{
  "kubernetes_namespace": "default"
}
EOT
}

resource "boundary_credential_library_vault" "k8s_ca" {
  name                = "k8s ca cred library"
  description         = "k8s ca credential library for k8s target"
  credential_store_id = boundary_credential_store_vault.hcp.id
  path                = "secret/data/k8s-cluster"
  http_method         = "GET"
}