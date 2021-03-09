
##########################################
# General Vars
##########################################

variable "env" {
  description = "Physical (software defined) grouping for infrastructure"
  type        = string
}

variable "location" {
  default     = "eastus"
  description = "Primary region used for project"
  type        = string
}

variable "owner" {
  description = "Maintainer of infrastructure"
  type        = string
}

variable "subscription_id" {
  description = "ID of subscription where resources will reside"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Resource Tags"
  type        = map(string)
}

##########################################
# AKS Vars
##########################################

variable "cluster_admin_group_display_name" {
  description = "Display name of cluster admins AAD group"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes. Retrieve list with `az aks get-versions -l eastus`"
  type        = string
}
