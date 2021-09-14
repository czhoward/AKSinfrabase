resource "azurerm_resource_group" "aksDemo" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_id" "random_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "AKSworkspace" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "${var.log_analytics_workspace_name}-${random_id.random_suffix.dec}"
  location            = var.log_analytics_workspace_location
  resource_group_name = azurerm_resource_group.aksDemo.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "AKSsolution" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.AKSworkspace.location
  resource_group_name   = azurerm_resource_group.aksDemo.name
  workspace_resource_id = azurerm_log_analytics_workspace.AKSworkspace.id
  workspace_name        = azurerm_log_analytics_workspace.AKSworkspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "aksDemo" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aksDemo.location
  resource_group_name = azurerm_resource_group.aksDemo.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "aksDemo"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  default_node_pool {
    name       = "agentpool"
    node_count = var.agent_count
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.AKSworkspace.id
    }
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
  }

  tags = {
    Environment = "Development"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.container_registry_name}${random_id.random_suffix.dec}"
  resource_group_name = azurerm_resource_group.aksDemo.name
  location            = azurerm_resource_group.aksDemo.location
  sku                 = var.container_registry_sku
  admin_enabled       = false
}

