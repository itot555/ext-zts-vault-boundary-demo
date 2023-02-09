# Organization scope: JOJO 7th demo organization
resource "boundary_auth_method_oidc" "auth0" {
  name               = "oidc-auth0"
  description        = "OIDC auth method with Auth0"
  scope_id           = boundary_scope.org1.id
  issuer             = var.app_domain
  client_id          = data.auth0_client.hcp_boundary.id
  client_secret      = data.auth0_client.hcp_boundary.client_secret
  signing_algorithms = ["RS256"]
  api_url_prefix     = data.terraform_remote_state.hcp.outputs.boundary_cluster_url
  account_claim_maps = [
    "name=name",
    "sub=sub",
    "email=email"
  ]
  claims_scopes = [
    "profile",
    "https://steelballrun.jojo/roles",
    "https://example.com/roles",
    "sub"
  ]
  state                = "active-public"
  is_primary_for_scope = true
  max_age              = 0
}