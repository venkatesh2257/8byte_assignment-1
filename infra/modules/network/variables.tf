variable "vpc_cidr" {}
variable "public_cidrs" { 
    type = list(string) 
    }
variable "private_cidrs" { 
    type = list(string) 
    }
variable "name" {}
variable "tags" {
     type = map(string) 
    }
variable "app_sg_id" {
  description = "Security group ID of the ECS app service"
  type        = string
}
