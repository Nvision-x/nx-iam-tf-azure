output "cluster_identity_id" {
  description = "AKS cluster managed identity ID"
  value       = module.nx-iam.cluster_identity_id
}

output "cluster_identity_client_id" {
  description = "AKS cluster managed identity client ID"
  value       = module.nx-iam.cluster_identity_client_id
}

output "kubelet_identity_id" {
  description = "AKS kubelet managed identity ID"
  value       = module.nx-iam.kubelet_identity_id
}

output "kubelet_identity_client_id" {
  description = "AKS kubelet managed identity client ID"
  value       = module.nx-iam.kubelet_identity_client_id
}

output "bastion_identity_id" {
  description = "Bastion VM managed identity ID"
  value       = module.nx-iam.bastion_identity_id
}

output "cluster_autoscaler_identity_client_id" {
  description = "Cluster Autoscaler identity client ID"
  value       = module.nx-iam.cluster_autoscaler_identity_client_id
}

output "openai_identity_client_id" {
  description = "Azure OpenAI identity client ID"
  value       = module.nx-iam.openai_identity_client_id
}
