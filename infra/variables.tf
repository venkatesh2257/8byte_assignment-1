variable "env" {
  description = "Environment name, e.g. dev/staging/prod"
  type        = string
}

variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "8byte"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password"
}

variable "db_instance" {
  type    = string
  default = "db.t4g.micro"
}

variable "db_storage_gb" {
  type    = number
  default = 20
}

variable "container_port" {
  type    = number
  default = 3000
}

variable "desired_count" {
  type    = number
  default = 1
}
