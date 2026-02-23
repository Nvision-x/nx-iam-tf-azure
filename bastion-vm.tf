################################################################################
# Bastion VM Managed Identity
# Equivalent to AWS Bastion EC2 IAM Role + Instance Profile
################################################################################

resource "azurerm_user_assigned_identity" "bastion" {
  count               = var.create && var.create_bastion_identity ? 1 : 0
  name                = "bastion-aks-role-${var.cluster_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# AKS Cluster Admin - full cluster access from bastion
resource "azurerm_role_assignment" "bastion_aks_admin" {
  count                = var.create && var.create_bastion_identity ? 1 : 0
  scope                = local.resource_group_id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = azurerm_user_assigned_identity.bastion[0].principal_id
}

# AKS RBAC Admin - manage RBAC within the cluster
resource "azurerm_role_assignment" "bastion_aks_rbac" {
  count                = var.create && var.create_bastion_identity ? 1 : 0
  scope                = local.resource_group_id
  role_definition_name = "Azure Kubernetes Service RBAC Admin"
  principal_id         = azurerm_user_assigned_identity.bastion[0].principal_id
}
