# Org1
output "org1_id" {
  value = boundary_scope.org1.id
}

output "project1_id" {
  value = boundary_scope.project1.id
}

output "auth_method_oidc_auth0" {
  value = boundary_auth_method_oidc.auth0.id
}

output "cred_store_id" {
  value = boundary_credential_store_vault.hcp.id
}

output "linux_host_id" {
  value = boundary_host_static.linux.*.id
}

output "linux_target_id" {
  value = boundary_target.linux.id
}

output "postgres_host_id" {
  value = boundary_host_static.postgres.id
}

output "postgres_ro_target_id" {
  value = boundary_target.postgres_ro.id
}

output "postgres_rw_target_id" {
  value = boundary_target.postgres_rw.id
}

output "k8s_host_id" {
  value = boundary_host_static.k8s.id
}

output "k8s_list_target_id" {
  value = boundary_target.k8s_list.id
}

output "k8s_all_target_id" {
  value = boundary_target.k8s_all.id
}