# variables.tf

variable "create" {
  description = "Master flag for creating resources"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "location" {
  description = "Azure region (e.g., eastus)"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# AKS Cluster Identity
################################################################################

variable "create_cluster_identity" {
  description = "Whether to create user-assigned managed identity for AKS cluster"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "Subnet IDs to grant Network Contributor role for AKS pod networking"
  type        = list(string)
  default     = []
}

variable "private_dns_zone_id" {
  description = "Private DNS Zone ID for private AKS cluster (optional)"
  type        = string
  default     = ""
}

################################################################################
# AKS Kubelet Identity
################################################################################

variable "create_kubelet_identity" {
  description = "Whether to create user-assigned managed identity for AKS kubelet"
  type        = bool
  default     = true
}

variable "acr_id" {
  description = "Azure Container Registry ID for AcrPull role assignment"
  type        = string
  default     = ""
}

################################################################################
# Bastion VM Identity
################################################################################

variable "create_bastion_identity" {
  description = "Whether to create the managed identity for Bastion VM"
  type        = bool
  default     = false
}

################################################################################
# Workload Identity (AKS OIDC)
################################################################################

variable "aks_oidc_issuer_url" {
  description = "AKS OIDC issuer URL for federated credentials (available after cluster creation)"
  type        = string
  default     = ""
}

################################################################################
# Cluster Autoscaler
################################################################################

variable "enable_cluster_autoscaler" {
  description = "Enable Cluster Autoscaler managed identity"
  type        = bool
  default     = false
}

variable "autoscaler_namespace" {
  description = "Kubernetes namespace for cluster autoscaler"
  type        = string
  default     = "kube-system"
}

variable "autoscaler_service_account" {
  description = "Kubernetes service account for cluster autoscaler"
  type        = string
  default     = "cluster-autoscaler"
}

variable "node_resource_group_id" {
  description = "AKS node resource group ID (MC_*) for autoscaler VMSS permissions"
  type        = string
  default     = ""
}

################################################################################
# PostgreSQL Backup
################################################################################

variable "enable_postgres" {
  description = "Enable PostgreSQL backup managed identity"
  type        = bool
  default     = false
}

variable "postgres_backup_namespace" {
  description = "Kubernetes namespace for PostgreSQL backup"
  type        = string
  default     = "default"
}

variable "postgres_backup_service_account" {
  description = "Kubernetes service account for PostgreSQL backup"
  type        = string
  default     = "databases-postgres-backup-sa"
}

variable "postgres_storage_account_id" {
  description = "Storage account ID for PostgreSQL backup data"
  type        = string
  default     = ""
}

################################################################################
# Application Storage Access (S3 equivalent)
################################################################################

variable "enable_app_storage_access" {
  description = "Enable application storage access managed identity"
  type        = bool
  default     = false
}

variable "app_storage_account_id" {
  description = "Storage account ID for application access"
  type        = string
  default     = ""
}

variable "app_storage_service_accounts" {
  description = "List of namespace:serviceaccount pairs for storage access. Example: [\"default:archiver\", \"default:enricher\"]"
  type        = list(string)
  default     = []
}

################################################################################
# Azure OpenAI Access (Bedrock equivalent)
################################################################################

variable "enable_openai_access" {
  description = "Enable Azure OpenAI managed identity for AKS pods"
  type        = bool
  default     = false
}

variable "openai_account_id" {
  description = "Azure OpenAI account resource ID"
  type        = string
  default     = ""
}

variable "openai_service_accounts" {
  description = "List of namespace:serviceaccount pairs for OpenAI access. Example: [\"default:ai-app\", \"production:ai-service\"]"
  type        = list(string)
  default     = []
}

################################################################################
# Azure AI Search (OpenSearch equivalent)
################################################################################

variable "enable_ai_search" {
  description = "Enable Azure AI Search managed identity"
  type        = bool
  default     = false
}

variable "ai_search_service_id" {
  description = "Azure AI Search service resource ID"
  type        = string
  default     = ""
}
