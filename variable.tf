variable "name" {
  description = "Esse valor será usado para nomear todos os recursos criados no Azure. Deve conter apenas caractéres alfanuméricos e minusculos."
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default = "East US"
}
