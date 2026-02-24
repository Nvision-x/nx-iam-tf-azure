################################################################################
# AKS Cluster Identity
################################################################################

output "cluster_identity_id" {
  description = "User-assigned managed identity ID for AKS cluster"
  value       = try(azurerm_user_assigned_identity.cluster[0].id, null)
}

output "cluster_identity_client_id" {
  description = "Client ID of the AKS cluster managed identity"
  value       = try(azurerm_user_assigned_identity.cluster[0].client_id, null)
}

output "cluster_identity_principal_id" {
  description = "Principal ID of the AKS cluster managed identity"
  value       = try(azurerm_user_assigned_identity.cluster[0].principal_id, null)
}

################################################################################
# Kubelet Identity
################################################################################

output "kubelet_identity_id" {
  description = "User-assigned managed identity ID for AKS kubelet"
  value       = try(azurerm_user_assigned_identity.kubelet[0].id, null)
}

output "kubelet_identity_client_id" {
  description = "Client ID of the kubelet managed identity"
  value       = try(azurerm_user_assigned_identity.kubelet[0].client_id, null)
}

output "kubelet_identity_principal_id" {
  description = "Principal ID of the kubelet managed identity"
  value       = try(azurerm_user_assigned_identity.kubelet[0].principal_id, null)
}

################################################################################
# Bastion Identity
################################################################################

output "bastion_identity_id" {
  description = "Bastion VM managed identity ID"
  value       = try(azurerm_user_assigned_identity.bastion[0].id, null)
}

output "bastion_identity_client_id" {
  description = "Client ID of the bastion managed identity"
  value       = try(azurerm_user_assigned_identity.bastion[0].client_id, null)
}

output "bastion_identity_principal_id" {
  description = "Principal ID of the bastion managed identity"
  value       = try(azurerm_user_assigned_identity.bastion[0].principal_id, null)
}

################################################################################
# Cluster Autoscaler Identity
################################################################################

output "cluster_autoscaler_identity_id" {
  description = "Cluster Autoscaler managed identity ID"
  value       = try(azurerm_user_assigned_identity.cluster_autoscaler[0].id, null)
}

output "cluster_autoscaler_identity_client_id" {
  description = "Cluster Autoscaler managed identity client ID"
  value       = try(azurerm_user_assigned_identity.cluster_autoscaler[0].client_id, null)
}

output "cluster_autoscaler_identity_principal_id" {
  description = "Cluster Autoscaler managed identity principal ID"
  value       = try(azurerm_user_assigned_identity.cluster_autoscaler[0].principal_id, null)
}

################################################################################
# PostgreSQL Backup Identity
################################################################################

output "postgres_backup_identity_id" {
  description = "PostgreSQL Backup managed identity ID"
  value       = try(azurerm_user_assigned_identity.postgres_backup[0].id, null)
}

output "postgres_backup_identity_client_id" {
  description = "PostgreSQL Backup managed identity client ID"
  value       = try(azurerm_user_assigned_identity.postgres_backup[0].client_id, null)
}

output "postgres_backup_identity_principal_id" {
  description = "PostgreSQL Backup managed identity principal ID"
  value       = try(azurerm_user_assigned_identity.postgres_backup[0].principal_id, null)
}

################################################################################
# Application Storage Identity
################################################################################

output "app_storage_identity_id" {
  description = "Application Storage Access managed identity ID"
  value       = try(azurerm_user_assigned_identity.app_storage[0].id, null)
}

output "app_storage_identity_client_id" {
  description = "Application Storage Access managed identity client ID"
  value       = try(azurerm_user_assigned_identity.app_storage[0].client_id, null)
}

output "app_storage_identity_principal_id" {
  description = "Application Storage Access managed identity principal ID"
  value       = try(azurerm_user_assigned_identity.app_storage[0].principal_id, null)
}

################################################################################
# Azure OpenAI Identity
################################################################################

output "openai_identity_id" {
  description = "Azure OpenAI managed identity ID"
  value       = try(azurerm_user_assigned_identity.openai[0].id, null)
}

output "openai_identity_client_id" {
  description = "Azure OpenAI managed identity client ID"
  value       = try(azurerm_user_assigned_identity.openai[0].client_id, null)
}

output "openai_identity_principal_id" {
  description = "Azure OpenAI managed identity principal ID"
  value       = try(azurerm_user_assigned_identity.openai[0].principal_id, null)
}

################################################################################
# Azure AI Search Identity
################################################################################

output "ai_search_identity_id" {
  description = "Azure AI Search managed identity ID"
  value       = try(azurerm_user_assigned_identity.ai_search[0].id, null)
}

output "ai_search_identity_client_id" {
  description = "Azure AI Search managed identity client ID"
  value       = try(azurerm_user_assigned_identity.ai_search[0].client_id, null)
}

output "ai_search_identity_principal_id" {
  description = "Azure AI Search managed identity principal ID"
  value       = try(azurerm_user_assigned_identity.ai_search[0].principal_id, null)
}
