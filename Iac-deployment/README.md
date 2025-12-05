DevOps One‑Click Deployment Assignment
This project deploys a simple Python REST API on private EC2 instances behind an Application Load Balancer (ALB) and Auto Scaling Group (ASG) using Terraform. Deployment can be triggered locally with a script or via GitHub Actions.​

Architecture
VPC with 2 public and 2 private subnets.

Internet Gateway and NAT Gateway for outbound internet from private subnets.

Public ALB (HTTP on port 80) routing to an ASG of EC2 instances in private subnets.

EC2 instances (Amazon Linux 2) run a Python Flask API on port 8080.

IAM role with AWS‑managed CloudWatch and SSM policies (no hard‑coded secrets).​

Repo structure
terraform/ – Terraform IaC for VPC, NAT, ALB, ASG, EC2, IAM.

app/ – Python Flask API code.

scripts/ – Helper scripts (deploy.sh, destroy.sh, test.sh).

.github/workflows/ – GitHub Actions workflows for deploy/destroy.​

Prerequisites
AWS account with IAM user/keys allowed to create VPC, subnets, ALB, ASG, EC2, IAM roles, etc.

Terraform 1.0+ installed locally.

Git installed.

For GitHub Actions: repository secrets set:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY​

Application details
The Python app (Flask) runs on port 8080 and exposes:​

GET / → returns simple text (e.g., “Hello from DevOps assignment!”).

GET /health → returns ok.

Logs are printed to stdout.​

Terraform configuration
In terraform/terraform.tfvars, set:​

text
aws_region   = "ap-south-1"        # or your preferred region
app_git_repo = "https://github.com/<your-user>/<this-repo>.git"
Other defaults (VPC CIDR, subnets, ASG sizes) are set in variables.tf and can be overridden in terraform.tfvars if needed.​

One‑click local deploy
From repo root:

Make scripts executable (once):

bash
chmod +x scripts/deploy.sh scripts/destroy.sh scripts/test.sh
Deploy the stack:

bash
./scripts/deploy.sh
After apply finishes, test the API:

bash
./scripts/test.sh
This script reads the ALB DNS from terraform output alb_dns_name and calls:​

http://<alb_dns>/

http://<alb_dns>/health

Destroy the stack when done:

bash
./scripts/destroy.sh
This satisfies the one‑click deploy and teardown requirements.​

GitHub Actions deployment
GitHub Actions workflows are under .github/workflows/.​

deploy.yml:

Triggered on push to main and manually via “Run workflow”.

Steps: checkout, configure AWS credentials from secrets, terraform init, terraform apply -auto-approve in terraform/.

destroy.yml (optional):

Triggered manually via “Run workflow”.

Runs terraform destroy -auto-approve in terraform/.

Before using these, ensure:​

AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are set as repo secrets.

Terraform state backend (default local) is acceptable for your use case.