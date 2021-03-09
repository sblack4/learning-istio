
data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

locals {
  location = "East US"
  name     = "EUS1-DEV-ISTIO"

  common_tags = merge(var.tags, {
    Environment         = var.env
    Owner               = var.owner
    terraform_managed   = true
    terraform_workspace = terraform.workspace
  })
}


##########################################
# AKS
##########################################

data "azuread_group" "cluster_admins" {
  display_name = var.cluster_admin_group_display_name
}

resource "azurerm_resource_group" "cluster" {
  name     = "EUS1-DEV-ISTIO-RG"
  location = local.location
}

resource "azurerm_virtual_network" "cluster" {
  name                = "EUS1-DEV-ISTIO-VNET"
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
  address_space       = ["10.25.0.0/16"]
  tags                = local.common_tags

  subnet {
    name           = "EUS1-DEV-ISTIO-NET"
    address_prefix = "10.25.16.0/20"
  }

  # Special subnet
  #   subnet {
  #     name           = "subnet2"
  #     address_prefix = "10.25.32.0/20"
  #   }

  subnet {
    name           = "sally-rides-the-subnet"
    address_prefix = "10.25.48.0/20"
  }
}

#tfsec:ignore:AZU008
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "EUS1DEVISTIOAKS"
  dns_prefix          = "EUS1DEVISTIOAKS"
  kubernetes_version  = var.kubernetes_version
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
  tags                = local.common_tags

  addon_profile {
    aci_connector_linux {
      enabled = false
    }
    azure_policy {
      enabled = false
    }
    http_application_routing {
      enabled = false
    }
    kube_dashboard {
      enabled = false
    }
    oms_agent {
      #tfsec:ignore:AZU009
      enabled = false
    }
  }

  default_node_pool {
    name                = "default"
    enable_auto_scaling = true
    max_count           = 10
    min_count           = 3
    vm_size             = "Standard_B4ms"

    # why tolist() on the subnet? terriform is y:
    # Error: Invalid index
    #   on main.tf line 81, in resource "azurerm_kubernetes_cluster" "aks":
    #   81:     vnet_subnet_id      = azurerm_virtual_network.cluster.subnet[0].id
    # This value does not have any indices.
    vnet_subnet_id = tolist(azurerm_virtual_network.cluster.subnet)[0].id
  }

  network_profile {
    dns_service_ip     = "10.250.8.10"
    docker_bridge_cidr = "172.17.0.1/16"
    load_balancer_sku  = "Standard"
    network_plugin     = "azure"
    network_policy     = "azure"
    pod_cidr           = null
    service_cidr       = "10.250.8.0/21"
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed                = true
      admin_group_object_ids = [data.azuread_group.cluster_admins.id]
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

# TODO: doesn't work
# resource "azurerm_role_assignment" "acrpull" {
#   scope                = azurerm_container_registry.acr[0].id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
# }

resource "azurerm_role_assignment" "network_contributor" {
  scope                = tolist(azurerm_virtual_network.cluster.subnet)[0].id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}
