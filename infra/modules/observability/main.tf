resource "aws_cloudwatch_dashboard" "infra" {
  dashboard_name = "${var.name}-infra"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "text",
        x    = 0,
        y    = 0,
        width = 24,
        height = 6,
        properties = {
          markdown = "# ${var.name} Infrastructure Dashboard\n\n✅ Deployment Successful!\n\nALB, ECS, and RDS resources deployed in ap-south-1 region."
        }
      }
    ]
  })
}

output "dashboard_name" {
  value = aws_cloudwatch_dashboard.infra.dashboard_name
}
