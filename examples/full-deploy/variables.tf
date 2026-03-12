variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "create_cluster_identity" {
  type    = bool
  default = true
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "create_kubelet_identity" {
  type    = bool
  default = true
}

variable "acr_id" {
  type    = string
  default = ""
}

variable "create_bastion_identity" {
  type    = bool
  default = false
}

variable "aks_oidc_issuer_url" {
  type    = string
  default = ""
}

variable "enable_cluster_autoscaler" {
  type    = bool
  default = false
}

variable "autoscaler_service_account" {
  type    = string
  default = "cluster-autoscaler"
}

variable "node_resource_group_id" {
  type    = string
  default = ""
}

variable "enable_openai_access" {
  type    = bool
  default = false
}

variable "openai_account_id" {
  type    = string
  default = ""
}

variable "openai_service_accounts" {
  type    = list(string)
  default = []
}
