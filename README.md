# Azure Terraform

1. Instalar a CLI do Azure
2. Logar via CLI
```
	$ az login
```
3. Exportar variáveis:

```
	$ export TF_VAR_client_id=<YourServicePrincipalClientID>
	$ export TF_vAR_client_secret=<YourServicePrincipalSecret>
```
4. Criar Storage Account e Blob Container:
```
	$ az group create --name MyResourceGroup --location eastus
	$ az storage account create --name YourAzureStorageAccountName --resource-group MyResourceGroup --access-tier Cool --sku Standard_LRS --kind StorageV2 --publish-internet-endpoints true
	$ az storage account show-connection-string --name YourAzureStorageAccountName --resource-group MyResourceGroup
	$ az storage container create -n tfstate --account-name=<YourAzureStorageAccountName> --account-key=<YourAzureStorageAccountKey>
```
5. Inicializar o Terraform
```
	$ terraform init -backend-config="storage_account_name=<YourAzureStorageAccountName>" -backend-config="container_name=tfstate" -backend-config="access_key=<YourAzureStorageAccountKey>" -backend-config="key=codelab.microsoft.tfstate"
	$ terraform plan -out out.plan 
	$ terraform apply out.plan
```
## Recursos Criados
1. AKS
2. ACR
3. PostgreSQL (para sonar)
4. Log Analytics
5. ContainerInsights para o AKS


