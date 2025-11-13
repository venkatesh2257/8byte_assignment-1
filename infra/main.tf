terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# ✅ Only one locals block (cleaned)
locals {
  name = trim(replace("${var.project}-${var.env}", " ", ""), "-")
}

# ---- NETWORK ----
module "network" {
  source         = "./modules/network"
  name           = local.name
  vpc_cidr       = var.vpc_cidr
  public_cidrs   = var.public_cidrs
  private_cidrs  = var.private_cidrs
  tags           = { Project = var.project, Env = var.env }
  app_sg_id       = module.security.app_sg_id
}

# ---- SECURITY GROUPS ----
module "security" {
  source   = "./modules/security"
  name     = local.name
  vpc_id   = module.network.vpc_id
  vpc_cidr = var.vpc_cidr
}

# ---- ALB ----
module "alb" {
  source            = "./modules/alb"
  name              = local.name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  sg_id             = module.security.alb_sg_id
  target_port       = var.container_port
  alb_ingress_cidrs = ["0.0.0.0/0"]
}

# ---- ECR ----
module "ecr" {
  source = "./modules/ecr"
  name   = local.name
}

# ---- ECS ----
module "ecs" {
  source             = "./modules/ecs"
  name               = local.name
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  container_port     = var.container_port
  desired_count      = var.desired_count
  target_group_arn   = module.alb.target_group_arn
  app_sg_id          = module.security.app_sg_id
  ecr_repo_url       = module.ecr.repository_url
  cw_log_group_name  = "/ecs/${local.name}"
}

# ---- RDS ----
module "rds" {
  source             = "./modules/rds"
  name               = local.name
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  db_username        = var.db_username
  db_password        = var.db_password
  db_instance        = var.db_instance
  db_storage_gb      = var.db_storage_gb
  app_sg_id          = module.security.app_sg_id
}

# ---- OBSERVABILITY ----
module "observability" {
  source         = "./modules/observability"
  name           = local.name
  alb_arn        = module.alb.alb_arn
  asg_like_arn   = module.ecs.service_arn
  db_instance_arn = module.rds.db_instance_arn
}

# ---- OUTPUTS ----
# Outputs are defined in outputs.tf







# locals {
#   name = replace(trimspace("${var.project}-${var.env}"), " ", "")
#   tags = { Project = trimspace(var.project), Env = trimspace(var.env) }
# }

# module "network" {
#   source        = "./modules/network"
#   vpc_cidr      = var.vpc_cidr
#   public_cidrs  = var.public_cidrs
#   private_cidrs = var.private_cidrs
#   name          = local.name
#   tags          = local.tags
# }

# module "security" {
#   source = "./modules/security"
#   vpc_id = module.network.vpc_id
#   vpc_cidr = var.vpc_cidr
#   name   = local.name
# }

# module "ecr" {
#   source = "./modules/ecr"
#   name   = local.name
# }

# module "alb" {
#   source             = "./modules/alb"
#   name               = local.name
#   vpc_id             = module.network.vpc_id
#   public_subnet_ids  = module.network.public_subnet_ids
#   target_port        = var.container_port
#   alb_ingress_cidrs  = ["0.0.0.0/0"]   # restrict in prod
#   sg_id              = module.security.alb_sg_id
# }

# module "rds" {
#   source              = "./modules/rds"
#   name                = local.name
#   vpc_id              = module.network.vpc_id
#   private_subnet_ids  = module.network.private_subnet_ids
#   db_username         = var.db_username
#   db_password         = var.db_password
#   db_instance         = var.db_instance
#   db_storage_gb       = var.db_storage_gb
#   app_sg_id           = module.security.app_sg_id
# }

# module "ecs" {
#   source               = "./modules/ecs"
#   name                 = local.name
#   vpc_id               = module.network.vpc_id
#   private_subnet_ids   = module.network.private_subnet_ids
#   container_port       = var.container_port
#   desired_count        = var.desired_count
#   ecr_repo_url         = module.ecr.repository_url
#   target_group_arn     = module.alb.target_group_arn
#   app_sg_id            = module.security.app_sg_id
#   cw_log_group_name    = "/ecs/${local.name}"
# }

# module "observability" {
#   source = "./modules/observability"
#   name   = local.name
#   alb_arn = module.alb.alb_arn
#   asg_like_arn = module.ecs.service_arn
#   db_instance_arn = module.rds.db_instance_arn
# }
