// Output AKS Resources
output "AKS_Kube_Config" {
  value = azurerm_kubernetes_cluster.aksterraform.kube_config_raw
}

// Output Azure Container Registry Resources
output "ACR_Admin_Password" {
  value = azurerm_container_registry.AzureContainerRegistry.admin_password
}

output "ACR_Admin_Username" {
  value = azurerm_container_registry.AzureContainerRegistry.admin_username
}

output "ACR_Login_Server" {
  value = azurerm_container_registry.AzureContainerRegistry.login_server
}

// Output PostgreSQL Resources
output "PSQL_Server_Name" {
  value = azurerm_postgresql_server.postgresqlserver.fqdn
}

output "PSQL_Server_Admin" {
  value = azurerm_postgresql_server.postgresqlserver.administrator_login
}

output "PSQL_Server_Password" {
  value = azurerm_postgresql_server.postgresqlserver.administrator_login_password
}

output "PSQL_Database" {
  value = azurerm_postgresql_database.postgresqldatabase.name
}
