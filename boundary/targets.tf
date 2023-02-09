# Create SSH target - host catalog
resource "boundary_host_catalog_static" "linux" {
  name        = "linux catalog"
  description = "for static Linux targets"
  scope_id    = boundary_scope.project1.id
}

# Create SSH target - host
resource "boundary_host_static" "linux" {
  count           = length(data.terraform_remote_state.aws.outputs.target_linux_instances)
  type            = "static"
  name            = "linux-ssh-${count.index + 1}"
  description     = "linux hosts"
  address         = data.terraform_remote_state.aws.outputs.target_linux_public_ip[count.index]
  host_catalog_id = boundary_host_catalog_static.linux.id
}

# Create SSH target - host set
resource "boundary_host_set_static" "linux" {
  host_catalog_id = boundary_host_catalog_static.linux.id
  type            = "static"
  name            = "linux ssh host set"
  description     = "linux ssh host set"
  host_ids        = boundary_host_static.linux.*.id
}

# Create SSH target - target
resource "boundary_target" "linux" {
  name         = "linux targets on aws"
  description  = "linux targets"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project1.id
  host_source_ids = [
    boundary_host_set_static.linux.id
  ]
  injected_application_credential_source_ids = [
    boundary_credential_library_vault.linux.id
  ]
  session_connection_limit = "-1"
}

# Create Postgres target - host catalog
resource "boundary_host_catalog_static" "postgres" {
  name        = "postgres catalog"
  description = "for static postgres targets"
  scope_id    = boundary_scope.project1.id
}

# Create Postgres target - host
resource "boundary_host_static" "postgres" {
  type            = "static"
  name            = "postgres"
  description     = "postgres hosts"
  address         = data.terraform_remote_state.aws.outputs.target_db_address
  host_catalog_id = boundary_host_catalog_static.postgres.id
}

# Create Postgres target - host set
resource "boundary_host_set_static" "postgres" {
  host_catalog_id = boundary_host_catalog_static.postgres.id
  type            = "static"
  name            = "postgres host set"
  description     = "postgres host set"
  host_ids        = [boundary_host_static.postgres.id]
}

# Create Postgres target - target with read only dynamic credential
resource "boundary_target" "postgres_ro" {
  name         = "postgres targets on aws - read only"
  description  = "postgres targets - read only credentials"
  type         = "tcp"
  default_port = "5432"
  scope_id     = boundary_scope.project1.id
  host_source_ids = [
    boundary_host_set_static.postgres.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.postgres_ro.id
  ]
  session_connection_limit = "-1"
}

# Create Postgres target - target with read write dynamic credential
resource "boundary_target" "postgres_rw" {
  name         = "postgres targets on aws - read write"
  description  = "postgres targets - read write credentials"
  type         = "tcp"
  default_port = "5432"
  scope_id     = boundary_scope.project1.id
  host_source_ids = [
    boundary_host_set_static.postgres.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.postgres_rw.id
  ]
  session_connection_limit = "-1"
}

# Create K8s target - host catalog
resource "boundary_host_catalog_static" "k8s" {
  name        = "k8s catalog"
  description = "k8s targets"
  scope_id    = boundary_scope.project1.id
}

# Create K8s target - host
resource "boundary_host_static" "k8s" {
  type            = "static"
  name            = "k8s_eks"
  description     = "eks cluster"
  address         = substr("${data.terraform_remote_state.aws.outputs.cluster_endpoint}", 8, -1)
  host_catalog_id = boundary_host_catalog_static.k8s.id
}

# Create K8s target (list pod) - host set
resource "boundary_host_set_static" "k8s_list" {
  host_catalog_id = boundary_host_catalog_static.k8s.id
  type            = "static"
  name            = "k8s cluster set - list pod"
  description     = "k8s host set - list pod"
  host_ids        = [boundary_host_static.k8s.id]
}

# Create K8s target (list pod) - target
resource "boundary_target" "k8s_list" {
  name         = "k8s targets on aws - list pod"
  description  = "k8s targets -list pod"
  type         = "tcp"
  default_port = "443"
  scope_id     = boundary_scope.project1.id
  host_source_ids = [
    boundary_host_set_static.k8s_list.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.k8s_list.id,
    boundary_credential_library_vault.k8s_ca.id
  ]
  session_connection_limit = "-1"
}

# Create K8s target (all) - host set
resource "boundary_host_set_static" "k8s_all" {
  host_catalog_id = boundary_host_catalog_static.k8s.id
  type            = "static"
  name            = "k8s cluster set - all role"
  description     = "k8s host set - all role"
  host_ids        = [boundary_host_static.k8s.id]
}

# Create K8s target (all) - target
resource "boundary_target" "k8s_all" {
  name         = "k8s targets on aws - all role"
  description  = "k8s targets - all role"
  type         = "tcp"
  default_port = "443"
  scope_id     = boundary_scope.project1.id
  host_source_ids = [
    boundary_host_set_static.k8s_all.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.k8s_all.id,
    boundary_credential_library_vault.k8s_ca.id
  ]
  session_connection_limit = "-1"
}