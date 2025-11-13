# CHALLENGES

1. ECS task IAM & ECR pull permissions  
   **Fix:** attached AmazonECSTaskExecutionRolePolicy; verified log + image pull.

2. Terraform state bootstrap chicken-egg  
   **Fix:** one-time manual S3/DDB creation; documented bootstrap steps.

3. Trivy failures on base image  
   **Fix:** pinned node:20-alpine; ignored-unfixed for demo, documented CVEs.

4. ALB healthcheck failing  
   **Fix:** added `/health` endpoint; matched port 3000; opened SG from ALB->App.

5. RDS connectivity  
   **Fix:** placed in private subnets; SG allows 5432 only from app SG; set correct env vars.
