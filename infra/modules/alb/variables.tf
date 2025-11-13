variable "name" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "target_port" {}
variable "alb_ingress_cidrs" { type = list(string) }
variable "sg_id" {}
