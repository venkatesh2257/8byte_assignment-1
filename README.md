# 8byte DevOps Assignment

## Architecture
- AWS VPC with public/private subnets
- ALB (public) -> ECS Fargate service (private)
- RDS PostgreSQL (private)
- Terraform state in S3 + DynamoDB locking
- CloudWatch logs, alarms, dashboards

## How to run
```bash
# Bootstrap (once): create S3 bucket + DynamoDB table for TF state
aws s3 mb s3://tfstate-8byte-yourname --region ap-south-1
aws dynamodb create-table --table-name tf-locks-8byte-yourname \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST --region ap-south-1

# Initialize & deploy staging
cd infra
terraform init -input=false
terraform apply -var-file=env/staging.tfvars
