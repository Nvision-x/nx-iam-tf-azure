data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "main" {
  count = var.create ? 1 : 0
  name  = var.resource_group_name
}

locals {
  create                  = var.create
  create_cluster_identity = local.create && var.create_cluster_identity
  create_kubelet_identity = local.create && var.create_kubelet_identity
  resource_group_id       = try(data.azurerm_resource_group.main[0].id, "")
}

################################################################################
# AKS Cluster Managed Identity
# Equivalent to AWS EKS Cluster IAM Role
################################################################################

resource "azurerm_user_assigned_identity" "cluster" {
  count               = local.create_cluster_identity ? 1 : 0
  name                = "${var.cluster_name}-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Network Contributor on subnets - required for AKS pod networking
resource "azurerm_role_assignment" "cluster_network" {
  for_each             = local.create_cluster_identity ? { for idx, id in var.subnet_ids : "subnet-${idx}" => id } : {}
  scope                = each.value
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster[0].principal_id
}

# Private DNS Zone Contributor - required for private AKS clusters
resource "azurerm_role_assignment" "cluster_dns" {
  count                = local.create_cluster_identity && var.private_dns_zone_id != "" ? 1 : 0
  scope                = var.private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster[0].principal_id
}

# Managed Identity Operator on kubelet identity - AKS needs to assign kubelet MI to nodes
resource "azurerm_role_assignment" "cluster_mi_operator" {
  count                = local.create_cluster_identity && local.create_kubelet_identity ? 1 : 0
  scope                = azurerm_user_assigned_identity.kubelet[0].id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.cluster[0].principal_id
}

################################################################################
# AKS Kubelet Managed Identity
# Equivalent to AWS EKS Managed Node Group IAM Role
################################################################################

resource "azurerm_user_assigned_identity" "kubelet" {
  count               = local.create_kubelet_identity ? 1 : 0
  name                = "${var.cluster_name}-kubelet"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# AcrPull - pull container images from Azure Container Registry
resource "azurerm_role_assignment" "kubelet_acr" {
  count                = local.create_kubelet_identity && var.acr_id != "" ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.kubelet[0].principal_id
}

# Contributor on node resource group - kubelet needs to manage disks, NICs
resource "azurerm_role_assignment" "kubelet_node_rg" {
  count                = local.create_kubelet_identity && var.node_resource_group_id != "" ? 1 : 0
  scope                = var.node_resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.kubelet[0].principal_id
}
