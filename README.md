# Azure Terraform

1. Instalar a CLI do Azure
2. Logar via CLI
```
	$ az login
```
3. Clonar esse repositório, ajustar o arquivo main.tf e executar:
```
	$ terraform init
	$ terraform plan --auto-approve
	$ terraform apply --auto-approve
```
## Recursos Criados
1. AKS
2. ACR
3. PostgreSQL (para sonar)
4. Log Analytics
5. ContainerInsights para o AKS
