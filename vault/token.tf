# Boundary controller policy
resource "vault_policy" "boundary_controller" {
  name = "boundary-controller"

  policy = <<EOT
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

path "sys/leases/renew" {
  capabilities = ["update"]
}

path "sys/leases/revoke" {
  capabilities = ["update"]
}

path "sys/capabilities-self" {
  capabilities = ["update"]
}
EOT
}

# Policy for credential injection
resource "vault_policy" "credential_inject" {
  name = "credential-inject-for-boundary"

  policy = <<EOT
path "secret/data/linux" {
  capabilities = ["read"]
}

path "postgres/creds/*" {
  capabilities = ["read"]
}
EOT
}

# Policy for k8s secret engine
resource "vault_policy" "k8s_jit_secrets" {
  name = "k8s-jit-secrets-for-boundary"

  policy = <<EOT
#Permissions to assume k8s secrets engine role and update (aka generate) K8s tokens 
path "kubernetes/creds/list-pod" {
  capabilities = ["update"]
}

path "kubernetes/creds/all-role" {
  capabilities = ["update"]
}
 
#Permissions to access Kubernetes CA certificate stored 
#in this path
path "secret/data/k8s-cluster" {
 capabilities = ["read"]
}
EOT
}

# Create token for boundary credential store
resource "vault_token" "boundary" {
  policies          = [vault_policy.boundary_controller.name, vault_policy.credential_inject.id, vault_policy.k8s_jit_secrets.id]
  no_parent         = true
  no_default_policy = true
  renewable         = true
  ttl               = "1440m"
  period            = "1440m"
}