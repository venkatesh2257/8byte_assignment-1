variable "name" {}
variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "db_username" {}
variable "db_password" {}
variable "db_instance" {}
variable "db_storage_gb" {}
variable "app_sg_id" {}
