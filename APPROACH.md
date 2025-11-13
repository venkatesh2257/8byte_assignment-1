
`APPROACH.md`
```md
# APPROACH

## Goals
Meet infra, CI/CD, monitoring/logging, docs, security, and backup requirements with minimal, reproducible code.

## Key Decisions
- **ECS Fargate** over EC2/EKS: fastest managed compute without managing nodes.
- **ALB** public to terminate HTTP; ECS in private subnets.
- **RDS Postgres** private; access only from app SG.
- **Terraform remote state** S3 + DynamoDB for team safety.
- **GitHub OIDC** to AWS for keyless deploys.
- **Trivy** for container & deps scanning.

## Trade-offs
- Single AZ for speed in staging; multi-AZ for prod.
- Plain HTTP on ALB (demo). In prod, use **ACM + HTTPS**.
- Minimal app logic per assignment (focus DevOps).

## What extra code would help?
- Blue/Green or canary deploy via CodeDeploy
- HTTPS/ACM + WAF on ALB
- RDS Proxy for connection pooling
- Infra tests (Terratest) + policy checks (tfsec)
