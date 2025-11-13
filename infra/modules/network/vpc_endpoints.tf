########################################
# VPC Interface & Gateway Endpoints
########################################

data "aws_region" "current" {}

# --------------------------------------
# Security Group for VPC Endpoints
# --------------------------------------
resource "aws_security_group" "endpoint_sg" {
  name        = "${var.name}-endpoint-sg"
  description = "Allow HTTPS access between ECS tasks and VPC interface endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "Allow HTTPS from ECS tasks"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }

  ingress {
    description = "Allow HTTPS within VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-endpoint-sg"
  })
}

# ✅ Separate SG rule to allow return HTTPS traffic from endpoints to ECS tasks
resource "aws_security_group_rule" "endpoint_to_app" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.endpoint_sg.id
  security_group_id        = var.app_sg_id
  description              = "Allow HTTPS response from endpoints to ECS tasks"
}

# --------------------------------------
# ECR API Endpoint (for GetAuthorizationToken)
# --------------------------------------
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoint_sg.id]

  tags = merge(var.tags, {
    Name = "${var.name}-ecr-api-endpoint"
  })
}

# --------------------------------------
# ECR DKR Endpoint (for Docker image pulls)
# --------------------------------------
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoint_sg.id]

  tags = merge(var.tags, {
    Name = "${var.name}-ecr-dkr-endpoint"
  })
}

# --------------------------------------
# CloudWatch Logs Endpoint (for ECS logs)
# --------------------------------------
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoint_sg.id]

  tags = merge(var.tags, {
    Name = "${var.name}-logs-endpoint"
  })
}

# --------------------------------------
# S3 Gateway Endpoint (for image layers)
# --------------------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]

  tags = merge(var.tags, {
    Name = "${var.name}-s3-endpoint"
  })
}
