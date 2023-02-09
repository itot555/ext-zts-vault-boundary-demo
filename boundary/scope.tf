# Organization scope: JOJO 7th demo organization
resource "boundary_scope" "org1" {
  name                     = "steel-ball-run-org"
  description              = "JOJO 7th demo organization"
  scope_id                 = "global"
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_scope" "project1" {
  name                   = "steel-ball-run-project"
  description            = "JOJO 7th demo project"
  scope_id               = boundary_scope.org1.id
  auto_create_admin_role = true
}