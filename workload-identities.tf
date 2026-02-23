################################################################################
# Workload Identities for AKS Pods
# Azure equivalent of AWS Pod Identity Roles
# Federated credentials are created when aks_oidc_issuer_url is provided
################################################################################

locals {
  create_federated_credentials = var.aks_oidc_issuer_url != ""

  # Parse namespace:serviceaccount pairs for app storage
  app_storage_sa_pairs = var.enable_app_storage_access && local.create_federated_credentials ? {
    for sa in var.app_storage_service_accounts :
    sa => {
      namespace = split(":", sa)[0]
      name      = split(":", sa)[1]
    }
  } : {}

  # Parse namespace:serviceaccount pairs for OpenAI
  openai_sa_pairs = var.enable_openai_access && local.create_federated_credentials ? {
    for sa in var.openai_service_accounts :
    sa => {
      namespace = split(":", sa)[0]
      name      = split(":", sa)[1]
    }
  } : {}
}

################################################################################
# Cluster Autoscaler
# Equivalent to AWS Cluster Autoscaler Pod Identity Role
################################################################################

resource "azurerm_user_assigned_identity" "cluster_autoscaler" {
  count               = var.create && var.enable_cluster_autoscaler ? 1 : 0
  name                = "${var.cluster_name}-cluster-autoscaler"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Virtual Machine Contributor on node resource group - scale VMSS up/down
resource "azurerm_role_assignment" "autoscaler_vmss" {
  count                = var.create && var.enable_cluster_autoscaler && var.node_resource_group_id != "" ? 1 : 0
  scope                = var.node_resource_group_id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster_autoscaler[0].principal_id
}

resource "azurerm_federated_identity_credential" "cluster_autoscaler" {
  count               = var.create && var.enable_cluster_autoscaler && local.create_federated_credentials ? 1 : 0
  name                = "autoscaler-${var.autoscaler_namespace}-${var.autoscaler_service_account}"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.cluster_autoscaler[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_oidc_issuer_url
  subject             = "system:serviceaccount:${var.autoscaler_namespace}:${var.autoscaler_service_account}"
}

################################################################################
# PostgreSQL Backup
# Equivalent to AWS Postgres Backup Pod Identity Role
################################################################################

resource "azurerm_user_assigned_identity" "postgres_backup" {
  count               = var.create && var.enable_postgres ? 1 : 0
  name                = "${var.cluster_name}-postgres-backup"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Storage Blob Data Contributor - read/write backup data
resource "azurerm_role_assignment" "postgres_storage" {
  count                = var.create && var.enable_postgres && var.postgres_storage_account_id != "" ? 1 : 0
  scope                = var.postgres_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.postgres_backup[0].principal_id
}

# Reader on PostgreSQL server - access server metadata (connection info, config)
resource "azurerm_role_assignment" "postgres_server_reader" {
  count                = var.create && var.enable_postgres && var.postgres_server_id != "" ? 1 : 0
  scope                = var.postgres_server_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.postgres_backup[0].principal_id
}

resource "azurerm_federated_identity_credential" "postgres_backup" {
  count               = var.create && var.enable_postgres && local.create_federated_credentials ? 1 : 0
  name                = "postgres-${var.postgres_backup_namespace}-${var.postgres_backup_service_account}"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.postgres_backup[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_oidc_issuer_url
  subject             = "system:serviceaccount:${var.postgres_backup_namespace}:${var.postgres_backup_service_account}"
}

################################################################################
# Application Storage Access
# Equivalent to AWS Application S3 Access Pod Identity Role
################################################################################

resource "azurerm_user_assigned_identity" "app_storage" {
  count               = var.create && var.enable_app_storage_access ? 1 : 0
  name                = "${var.cluster_name}-app-storage-access"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Storage Blob Data Contributor on the application storage account
resource "azurerm_role_assignment" "app_storage" {
  count                = var.create && var.enable_app_storage_access && var.app_storage_account_id != "" ? 1 : 0
  scope                = var.app_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.app_storage[0].principal_id
}

# Federated credentials for each service account that needs storage access
resource "azurerm_federated_identity_credential" "app_storage" {
  for_each            = local.app_storage_sa_pairs
  name                = "storage-${each.value.namespace}-${each.value.name}"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.app_storage[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_oidc_issuer_url
  subject             = "system:serviceaccount:${each.value.namespace}:${each.value.name}"
}

################################################################################
# Azure OpenAI Access
# Equivalent to AWS Bedrock Pod Identity Role
################################################################################

resource "azurerm_user_assigned_identity" "openai" {
  count               = var.create && var.enable_openai_access ? 1 : 0
  name                = "${var.cluster_name}-openai-access"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Cognitive Services OpenAI User - invoke models
resource "azurerm_role_assignment" "openai" {
  count                = var.create && var.enable_openai_access && var.openai_account_id != "" ? 1 : 0
  scope                = var.openai_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_user_assigned_identity.openai[0].principal_id
}

# Federated credentials for each service account that needs OpenAI access
resource "azurerm_federated_identity_credential" "openai" {
  for_each            = local.openai_sa_pairs
  name                = "openai-${each.value.namespace}-${each.value.name}"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.openai[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_oidc_issuer_url
  subject             = "system:serviceaccount:${each.value.namespace}:${each.value.name}"
}

################################################################################
# Azure AI Search
# Equivalent to AWS OpenSearch IAM Role
################################################################################

resource "azurerm_user_assigned_identity" "ai_search" {
  count               = var.create && var.enable_ai_search ? 1 : 0
  name                = "${var.cluster_name}-ai-search"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Search Index Data Contributor - read/write search indexes
resource "azurerm_role_assignment" "ai_search_index" {
  count                = var.create && var.enable_ai_search && var.ai_search_service_id != "" ? 1 : 0
  scope                = var.ai_search_service_id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = azurerm_user_assigned_identity.ai_search[0].principal_id
}

# Search Service Contributor - manage the search service
resource "azurerm_role_assignment" "ai_search_service" {
  count                = var.create && var.enable_ai_search && var.ai_search_service_id != "" ? 1 : 0
  scope                = var.ai_search_service_id
  role_definition_name = "Search Service Contributor"
  principal_id         = azurerm_user_assigned_identity.ai_search[0].principal_id
}

# Storage Blob Data Contributor - snapshot/backup to storage account
resource "azurerm_role_assignment" "ai_search_storage" {
  count                = var.create && var.enable_ai_search && var.ai_search_backup_storage_account_id != "" ? 1 : 0
  scope                = var.ai_search_backup_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.ai_search[0].principal_id
}
