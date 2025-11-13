# ALB security group
resource "aws_security_group" "alb_sg" {
  name   = "${var.name}-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# App security group
resource "aws_security_group" "app_sg" {
  name   = "${var.name}-app-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "alb_to_app" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.app_sg.id
}

output "alb_sg_id" { value = aws_security_group.alb_sg.id }
# output "app_sg_id" { value = aws_security_group.app_sg.id }
