# KV-v2 secrets engine
resource "vault_mount" "kvv2" {
  path        = "secret"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount for static credential injection"
}

# KV-v2 for linux targets
resource "vault_kv_secret_v2" "linux" {
  mount               = vault_mount.kvv2.path
  name                = "linux"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      username    = "ubuntu"
      private_key = "${data.terraform_remote_state.aws.outputs.boundary_targets_private_key_openssh}"
    }
  )
  depends_on = [
    vault_mount.kvv2
  ]
}

# KV-v2 for EKS CA cert
resource "vault_kv_secret_v2" "eks_ca_crt" {
  mount               = vault_mount.kvv2.path
  name                = "k8s-cluster"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      ca_crt = base64decode(data.terraform_remote_state.aws.outputs.cluster_certificate_authority_data)
    }
  )
  depends_on = [
    vault_mount.kvv2
  ]
}

# DB secrets engine
resource "vault_mount" "db" {
  path = "postgres"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.db.path
  name          = "postgres"
  allowed_roles = ["readonly", "readwrite"]

  postgresql {
    connection_url = "postgres://{{username}}:{{password}}@${data.terraform_remote_state.aws.outputs.target_db_endpoint}/${data.terraform_remote_state.aws.outputs.target_db_db_name}"
    username       = data.terraform_remote_state.aws.outputs.target_db_username
    password       = data.terraform_remote_state.aws.outputs.target_db_password
  }
}

resource "vault_database_secret_backend_role" "readonly" {
  backend             = vault_mount.db.path
  name                = "readonly"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';", "GRANT ro_demodb TO \"{{name}}\";"]
  default_ttl         = "1800"
  max_ttl             = "3600"
}

resource "vault_database_secret_backend_role" "readwrite" {
  backend             = vault_mount.db.path
  name                = "readwrite"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';", "GRANT rw_demodb TO \"{{name}}\";"]
  default_ttl         = "600"
  max_ttl             = "1800"
}

# Kubernetes Secrets Engine
resource "vault_kubernetes_secret_backend" "config" {
  path                      = "kubernetes"
  description               = "kubernetes secrets engine for eks"
  default_lease_ttl_seconds = 43200 #12h
  max_lease_ttl_seconds     = 86400
  kubernetes_host           = data.terraform_remote_state.aws.outputs.cluster_endpoint
  kubernetes_ca_cert        = base64decode(data.terraform_remote_state.aws.outputs.cluster_certificate_authority_data)
  service_account_jwt       = data.terraform_remote_state.aws.outputs.vault_service_account_token
  disable_local_ca_jwt      = false
}

resource "vault_kubernetes_secret_backend_role" "list" {
  backend = vault_kubernetes_secret_backend.config.path
  name                          = "list-pod"
  allowed_kubernetes_namespaces = ["*"]
  token_max_ttl                 = 1200
  token_default_ttl             = 600
  kubernetes_role_type          = "Role"
  generated_role_rules          = <<EOF
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list"]
EOF
}

resource "vault_kubernetes_secret_backend_role" "all" {
  backend                       = vault_kubernetes_secret_backend.config.path
  name                          = "all-role"
  allowed_kubernetes_namespaces = ["default", "vault"]
  token_max_ttl                 = 1200
  token_default_ttl             = 600
  kubernetes_role_type          = "Role"
  generated_role_rules          = <<EOF
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
EOF
}
