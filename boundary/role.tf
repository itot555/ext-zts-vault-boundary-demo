# Organization scope: JOJO 7th demo organization
resource "boundary_role" "admin" {
  name        = "steel-ball-run-project-admin"
  description = "admin role"
  principal_ids = [
    boundary_managed_group.joestar.id
  ]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.project1.id
}

resource "boundary_role" "linux" {
  name        = "steel-ball-run-project-linux-admin"
  description = "linux admin role"
  principal_ids = [
    boundary_managed_group.boss.id
  ]
  grant_strings = [
    "id=${boundary_target.linux.id};actions=*",
    "id=*;type=session;actions=cancel:self,list,read",
    "id=*;type=target;actions=list,read",
    "id=*;type=host-catalog;actions=list,read",
    "id=*;type=host-set;actions=list,read",
    "id=*;type=host;actions=list,read"
  ]
  scope_id = boundary_scope.project1.id
  depends_on = [
    boundary_host_catalog_static.linux,
    boundary_host_static.linux,
    boundary_host_set_static.linux,
    boundary_target.linux
  ]
}

resource "boundary_role" "ro" {
  name        = "steel-ball-run-project-readonly"
  description = "database and k8s cluster read only role"
  principal_ids = [
    boundary_managed_group.enemy.id
  ]
  grant_strings = [
    "id=${boundary_target.postgres_ro.id};actions=*",
    "id=${boundary_target.k8s_list.id};actions=*",
    "id=*;type=session;actions=cancel:self,list,read",
    "id=*;type=target;actions=list,read",
    "id=*;type=host-catalog;actions=list,read",
    "id=*;type=host-set;actions=list,read",
    "id=*;type=host;actions=list,read"
  ]
  scope_id = boundary_scope.project1.id
  depends_on = [
    boundary_host_catalog_static.postgres,
    boundary_host_static.postgres,
    boundary_host_set_static.postgres,
    boundary_target.postgres_ro,
    boundary_host_catalog_static.k8s,
    boundary_host_static.k8s,
    boundary_host_set_static.k8s_list,
    boundary_target.k8s_list
  ]
}