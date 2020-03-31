variable "name" {
  description = <<EOF
		"This value will be applied for all created resources."
		"Name must only contain lowercase alpha numeric characters (letters and numbers)."
		"Terraform will attach a randon 4 bytes length suffix to this name to create PostgreSQL and ACR names."
EOF
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default = "East US"
}

variable "client_id" {
}

variable "client_secret" {
}

variable "psql_user_admin" {
  description = <<EOF
		"Admin username must be at least 1 characters and at most 63 characters."
		"Admin username must only contain characters and numbers."
		"Admin login name cannot be 'azure_superuser', 'azure_pg_admin', 'admin', 'administrator', 'root', 'guest', 'public' or start with 'pg_'."
EOF
}

variable "psql_password" {
  description = <<EOF
		"Your password must be at least 8 characters and at most 128 characters." 
		"Your password must contain characters from three of the following categories – English uppercase letters, English lowercase letters, numbers (0-9), and non-alphanumeric characters (!, $, #, %, etc.)."
EOF
}
