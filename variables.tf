variable "subscription_id" {
  description = "Subscription ID de Azure - requerido explicitamente por el provider azurerm >= 4.0. Sin default: TF_VAR_subscription_id (NO ARM_SUBSCRIPTION_ID)."
  type        = string
}

variable "location" {
  description = "Azure region - must match the region of your shared network layer"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group dedicado a este proyecto"
  type        = string
  default     = "rg-aks-cluster"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "owner" {
  type = string
}

variable "project" {
  type    = string
  default = "aks-cluster"
}

variable "tags" {
  type    = map(string)
  default = {}
}

# ============================================================================
# Shared network layer - values copied by hand from your network project's
# outputs, no terraform_remote_state data source.
# ============================================================================

variable "network_aks_subnet_id" {
  description = "ID del subnet snet-aks (node pool real del cluster)"
  type        = string
}

variable "network_aks_virtual_nodes_subnet_id" {
  description = "ID del subnet snet-aks-virtual-nodes (delegado a Microsoft.ContainerInstance/containerGroups, para los pods ACI-backed)"
  type        = string
}

variable "network_appgw_subnet_id" {
  description = "ID del subnet snet-appgw, donde vive el Application Gateway que AGIC va a gestionar"
  type        = string
}

variable "network_log_analytics_workspace_id" {
  description = "ID del Log Analytics Workspace compartido - se reutiliza para Container Insights"
  type        = string
}

# ============================================================================
# AKS
# ============================================================================

variable "cluster_name" {
  type    = string
  default = "aks-cluster"
}

variable "dns_prefix" {
  type    = string
  default = "aks-cluster"
}

variable "kubernetes_version" {
  description = "Version de Kubernetes. null = la version default soportada por AKS al momento del apply."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "SKU del control plane (Free, Standard, Premium). Free alcanza para este proyecto."
  type        = string
  default     = "Free"
}

variable "default_node_pool_vm_size" {
  description = "VM size for the single real node in the cluster. The hello-world workload runs on Virtual Nodes, not here - this node only hosts system components. Not every VM size is enabled in every subscription/region - if `terraform apply` rejects this SKU with a 400, check your subscription's allowed sizes and pick another."
  type        = string
  default     = "Standard_D2s_v7"
}

variable "default_node_pool_node_count" {
  description = "Number of real nodes hosting system components (CoreDNS, kube-proxy, CSI drivers, Azure CNS, AGIC, ACI connector) - these can NOT run on Virtual Nodes since they need hostNetwork/host access, which ACI does not provide. Check your subscription's regional vCPU quota before raising this - it's a common wall to hit."
  type        = number
  default     = 2
}

# ============================================================================
# ACR
# ============================================================================

variable "acr_name" {
  description = "Nombre del Azure Container Registry - debe ser unico globalmente"
  type        = string
  default     = "acrakscluster"
}

# ============================================================================
# DNS + certificado
# ============================================================================

variable "dns_zone_name" {
  description = "EXISTING Azure DNS Zone where this project's record gets added. No default - set to your own zone."
  type        = string
}

variable "dns_zone_resource_group_name" {
  description = "Resource group of the existing DNS Zone. No default - set to your own."
  type        = string
}

variable "dns_record_name" {
  description = "Nombre del registro A -> FQDN final = <dns_record_name>.<dns_zone_name>"
  type        = string
  default     = "aks"
}

variable "acme_email" {
  description = "Email para la cuenta ACME de Let's Encrypt. Sin default."
  type        = string
}

variable "acme_server_url" {
  description = "Endpoint del directorio ACME. Usa el de staging mientras iteras (5 duplicados/semana en produccion)."
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

# ============================================================================
# Application Gateway
# ============================================================================

variable "app_gateway_name" {
  type    = string
  default = "appgw-aks-cluster"
}

variable "app_gateway_sku_capacity" {
  type    = number
  default = 1
}
