output "alb_dns_name" { value = module.alb.alb_dns_name }
output "service_url"  { value = "http://${module.alb.alb_dns_name}" }
output "rds_endpoint" { value = module.rds.rds_endpoint }
output "ecr_repo"     { value = module.ecr.repository_url }
