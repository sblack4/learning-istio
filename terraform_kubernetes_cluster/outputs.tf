
output "virtual_network_id" {
  value = azurerm_virtual_network.cluster
}

##########################################
# AKS
##########################################

output "aks_admin_password" {
  description = "AKS admin password"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.password
}

output "aks_admin_username" {
  description = "AKS admin username"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.username
}

output "aks_client_certificate" {
  description = "AKS cluster client certificate"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate
}

output "aks_client_key" {
  description = "AKS cluster client key"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key
}

output "aks_cluster_ca_certificate" {
  description = "AKS Cluster CA Cert"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate
}

output "aks_cluster_name" {
  description = "AKS Cluster Name"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_cluster_resource_group_name" {
  description = "AKS Cluster resource_group_name"
  value       = azurerm_kubernetes_cluster.aks.resource_group_name
}

output "aks_host" {
  description = "AKS APIServer Hostname"
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.host
}

output "aks_kubeconfig_raw" {
  description = "Raw admin kubeconfig for AKS"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
}

output "aks_msi_id" {
  description = "Managed Service Identity for AKS ID"
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}
