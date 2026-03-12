cluster_name        = "aks-dev"
resource_group_name = "nx-aks-rg"
location            = "eastus"

# AKS Cluster + Kubelet identities
create_cluster_identity = true
create_kubelet_identity = true

# Subnet IDs for Network Contributor (from nx-networking-tf-azure output)
subnet_ids = []

# ACR ID (from container registry module)
acr_id = ""

# Bastion
create_bastion_identity = true

# Workload Identity - OIDC issuer URL from AKS cluster
# Note: Set this after AKS cluster is created (from nx-infra-tf-azure output)
aks_oidc_issuer_url = ""

# Cluster Autoscaler
enable_cluster_autoscaler  = true
autoscaler_service_account = "cluster-autoscaler"
node_resource_group_id     = ""

# Azure OpenAI (Bedrock equivalent)
enable_openai_access    = false
openai_account_id       = ""
openai_service_accounts = []
