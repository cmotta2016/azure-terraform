// Gera uma sequencia randomica para acrescertar ao nome de determinados recursos
resource "random_id" "name" {
  byte_length = 4
}

// Log Analytics for AKS
resource "azurerm_resource_group" "loganalytics" {
  name     = "${var.name}LogAnalytics"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "loganalyticsworkspace" {
  name                = "${var.name}-law"
  location            = azurerm_resource_group.loganalytics.location
  resource_group_name = azurerm_resource_group.loganalytics.name
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "loganalyticsaks" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.loganalytics.location
  resource_group_name   = azurerm_resource_group.loganalytics.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalyticsworkspace.id
  workspace_name        = azurerm_log_analytics_workspace.loganalyticsworkspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

// AKS Cluster
resource "azurerm_resource_group" "rgaksterraform" {
  name     = "${var.name}AzureKubernetesService"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aksterraform" {
  name                = "${var.name}-k8s"
  location            = azurerm_resource_group.rgaksterraform.location
  resource_group_name = azurerm_resource_group.rgaksterraform.name
  dns_prefix          = "${var.name}-aks-dns"

  default_node_pool {
    name       = "agentpool"
    node_count = 1
    vm_size    = "Standard_D2s_v3"
    enable_auto_scaling = true
    max_count = 2
    min_count = 1
  }

  addon_profile {
      http_application_routing {
          enabled = false
       }

      kube_dashboard {
          enabled = true
       }

      oms_agent {
          enabled = true
          log_analytics_workspace_id = azurerm_log_analytics_workspace.loganalyticsworkspace.id
       }
   }

  network_profile {
    network_plugin = "kubenet"
  }

  role_based_access_control {
    enabled = true
  }
 
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = "Dev"
  }
}

// Azure Container Registry
resource "azurerm_resource_group" "AzureContainerRegistry" {
  name     = "${var.name}AzureContainerRegistry"
  location = var.location
}

resource "azurerm_container_registry" "AzureContainerRegistry" {
  name                = "${var.name}${random_id.name.hex}"
  resource_group_name = azurerm_resource_group.AzureContainerRegistry.name
  location            = azurerm_resource_group.AzureContainerRegistry.location
  sku                 = "Basic"
  admin_enabled       = true
}

// Azure PostgreSQL
resource "azurerm_resource_group" "postgresqlrg" {
  name     = "${var.name}PostgreSQL"
  location = var.location
}

resource "azurerm_postgresql_server" "postgresqlserver" {
  name                = "${var.name}${random_id.name.hex}"
  location            = azurerm_resource_group.postgresqlrg.location
  resource_group_name = azurerm_resource_group.postgresqlrg.name

  sku_name = "B_Gen5_1"

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
    auto_grow             = "Disabled"
  }
  administrator_login          = var.psql_user_admin
  administrator_login_password = var.psql_password
  version                      = "9.6"
  ssl_enforcement              = "Disabled"
}

resource "azurerm_postgresql_database" "postgresqldatabase" {
  name                = "${var.name}db"
  resource_group_name = azurerm_resource_group.postgresqlrg.name
  server_name         = azurerm_postgresql_server.postgresqlserver.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "postgresqlfirewall" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.postgresqlrg.name
  server_name         = azurerm_postgresql_server.postgresqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
