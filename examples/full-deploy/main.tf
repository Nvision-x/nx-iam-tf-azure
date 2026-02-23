module "nx-iam" {
  source = "../.."
  # source = "git::https://github.com/Nvision-x/nx-iam-tf-azure.git"

  cluster_name        = var.cluster_name
  resource_group_name = var.resource_group_name
  location            = var.location

  # AKS Cluster Identity
  create_cluster_identity = var.create_cluster_identity
  subnet_ids              = var.subnet_ids

  # Kubelet Identity
  create_kubelet_identity = var.create_kubelet_identity
  acr_id                  = var.acr_id

  # Bastion
  create_bastion_identity = var.create_bastion_identity

  # Workload Identity
  aks_oidc_issuer_url = var.aks_oidc_issuer_url

  # Cluster Autoscaler
  enable_cluster_autoscaler  = var.enable_cluster_autoscaler
  autoscaler_service_account = var.autoscaler_service_account
  node_resource_group_id     = var.node_resource_group_id

  # OpenAI (Bedrock equivalent)
  enable_openai_access   = var.enable_openai_access
  openai_account_id      = var.openai_account_id
  openai_service_accounts = var.openai_service_accounts
}
