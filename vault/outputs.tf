output "vault_client_token_lease_duration" {
  description = "The token lease duration"
  value       = vault_token.boundary.lease_duration
}

output "vault_client_token_lease_started" {
  description = "The token lease started"
  value       = vault_token.boundary.lease_started
}

output "vault_client_token" {
  description = "Vault client token for Boundary controller"
  value       = vault_token.boundary.client_token
  sensitive   = true
}
