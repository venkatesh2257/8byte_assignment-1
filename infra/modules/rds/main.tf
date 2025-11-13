resource "aws_db_subnet_group" "this" {
  name        = replace(trimspace("db-${var.name}-subnet-group"), " ", "")
  description = "Database subnet group"
  subnet_ids  = var.private_subnet_ids
}

resource "aws_db_instance" "this" {
  identifier              = replace(trimspace("db-${var.name}-db"), " ", "")
  engine                  = "postgres"
  instance_class          = var.db_instance
  username                = var.db_username
  password                = var.db_password
  allocated_storage       = var.db_storage_gb
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.app_sg_id]
  skip_final_snapshot     = true
  publicly_accessible     = false
}

output "rds_endpoint" {
  value = aws_db_instance.this.address
}

output "db_instance_arn" {
  value = aws_db_instance.this.arn
}
