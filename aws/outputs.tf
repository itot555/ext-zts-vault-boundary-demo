# SSH key-pair for Boundary targets
output "boundary_targets_private_key_openssh" {
  description = "Private key data in OpenSSH PEM (RFC 4716) format."
  value       = tls_private_key.targets.private_key_openssh
  sensitive   = true
}

output "boundary_targets_private_key_pem" {
  description = "Private key data in PEM (RFC 1421) format."
  value       = tls_private_key.targets.private_key_pem
  sensitive   = true
}

output "boundary_targets_public_key_openssh" {
  description = "The public key data in Authorized Keys format."
  value       = tls_private_key.targets.public_key_openssh
}

# Target EC2 Instance
output "target_linux_public_ip" {
  description = "Public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use public_ip as this field will change after the EIP is attached."
  value       = aws_instance.linux.*.public_ip
}

output "target_linux_public_dns" {
  description = "Public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC."
  value       = aws_instance.linux.*.public_dns
}

# Target RDS for PostgreSQL
output "target_db_address" {
  description = "The hostname of the RDS instance. See also endpoint and port."
  value       = aws_db_instance.postgres.address
}

output "target_db_db_name" {
  description = "The database name."
  value       = aws_db_instance.postgres.db_name
}

output "target_db_endpoint" {
  description = "The connection endpoint in address:port format."
  value       = aws_db_instance.postgres.endpoint
}

output "target_db_username" {
  description = "The master username for the database."
  value       = aws_db_instance.postgres.username
}

# Target EKS Cluster
output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = module.eks.cluster_primary_security_group_id
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = module.eks.cluster_version
}

# Vault service account token on EKS
output "vault_service_account_token" {
  value     = kubernetes_secret_v1.vault.data.token
  sensitive = true
}

# VPC Module
output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# From variables
output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "target_linux_instances" {
  description = "Boundary target linuxs"
  value       = var.instances
}

output "target_db_password" {
  description = "Boundary target db password"
  value       = var.db_password
}