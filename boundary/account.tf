# steelballrun-boss
resource "boundary_account_oidc" "dio" {
  name           = "dio"
  description    = "Dio"
  auth_method_id = boundary_auth_method_oidc.auth0.id
  issuer         = var.app_domain
  subject        = var.auth0_user_id_dio
  depends_on = [
    boundary_auth_method_oidc.auth0
  ]
}

resource "boundary_account_oidc" "valentine" {
  name           = "valentine"
  description    = "Valentine"
  auth_method_id = boundary_auth_method_oidc.auth0.id
  issuer         = var.app_domain
  subject        = var.auth0_user_id_valentine
  depends_on = [
    boundary_auth_method_oidc.auth0
  ]
}

# steelballrun-joestar
resource "boundary_account_oidc" "jony" {
  name           = "jony"
  description    = "Jony"
  auth_method_id = boundary_auth_method_oidc.auth0.id
  issuer         = var.app_domain
  subject        = var.auth0_user_id_jony
  depends_on = [
    boundary_auth_method_oidc.auth0
  ]
}

resource "boundary_account_oidc" "gyro" {
  name           = "gyro"
  description    = "Gyro"
  auth_method_id = boundary_auth_method_oidc.auth0.id
  issuer         = var.app_domain
  subject        = var.auth0_user_id_gyro
  depends_on = [
    boundary_auth_method_oidc.auth0
  ]
}

# steelballrun-enemy
resource "boundary_account_oidc" "blackmore" {
  name           = "blackmore"
  description    = "Blackmore"
  auth_method_id = boundary_auth_method_oidc.auth0.id
  issuer         = var.app_domain
  subject        = var.auth0_user_id_blackmore
  depends_on = [
    boundary_auth_method_oidc.auth0
  ]
}

resource "boundary_user" "dio" {
  name        = "dio"
  description = "Dio's user resource"
  account_ids = [boundary_account_oidc.dio.id]
  scope_id    = boundary_scope.org1.id
}

resource "boundary_user" "valentine" {
  name        = "valentine"
  description = "Valentine's user resource"
  account_ids = [boundary_account_oidc.valentine.id]
  scope_id    = boundary_scope.org1.id
}

resource "boundary_user" "jony" {
  name        = "jony"
  description = "Jony's user resource"
  account_ids = [boundary_account_oidc.jony.id]
  scope_id    = boundary_scope.org1.id
}

resource "boundary_user" "gyro" {
  name        = "gyro"
  description = "Gyro's user resource"
  account_ids = [boundary_account_oidc.gyro.id]
  scope_id    = boundary_scope.org1.id
}

resource "boundary_user" "blackmore" {
  name        = "blackmore"
  description = "Blackmore's user resource"
  account_ids = [boundary_account_oidc.blackmore.id]
  scope_id    = boundary_scope.org1.id
}

resource "boundary_managed_group" "boss" {
  name           = "boss"
  description    = "Boss OIDC managed group"
  auth_method_id = boundary_auth_method_oidc.auth0.id
  filter         = "\"valentine\" in \"/userinfo/nickname\" or \"dio\" in \"/userinfo/nickname\""
}

resource "boundary_managed_group" "joestar" {
  name           = "joestar"
  description    = "Joestar OIDC managed group"
  auth_method_id = boundary_auth_method_oidc.auth0.id
  filter         = "\"jony\" in \"/userinfo/nickname\" or \"gyro\" in \"/userinfo/nickname\""
}

resource "boundary_managed_group" "enemy" {
  name           = "enemy"
  description    = "Enemy OIDC managed group"
  auth_method_id = boundary_auth_method_oidc.auth0.id
  filter         = "\"blackmore\" in \"/userinfo/nickname\""
}