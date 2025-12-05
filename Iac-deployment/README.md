# DevOps One Click Deployment

This project deploys a small Python REST API on private EC2 instances. The application runs behind an Application Load Balancer and an Auto Scaling Group. All resources are created with Terraform. Deployment can be triggered locally with helper scripts or through GitHub Actions.

## Architecture

- VPC with two public and two private subnets
- Internet Gateway and NAT Gateway for outbound traffic from private subnets
- Public Application Load Balancer listening on port 80
- Auto Scaling Group of EC2 instances placed in private subnets
- EC2 instances (Amazon Linux 2) running a Python Flask API on port 8080
- IAM role with AWS managed SSM and CloudWatch policies

## Repository Structure

- `terraform/`  
  Terraform configuration for VPC, NAT, ALB, ASG, EC2 and IAM

- `app/`  
  Python Flask application

- `scripts/`  
  Helper scripts such as `deploy.sh`, `destroy.sh` and `test.sh`

- `.github/workflows/`  
  GitHub Actions workflows for deployment and teardown

## Prerequisites

- AWS account with permissions to create VPC, ALB, ASG, EC2 and IAM resources  
- Terraform version 1.0 or newer  
- Git installed  
- For GitHub Actions, repository secrets set for  
  - `AWS_ACCESS_KEY_ID`  
  - `AWS_SECRET_ACCESS_KEY`

## Application Details

The Python Flask application listens on port 8080 and exposes two routes.

- `GET /` returns a short text message  
- `GET /health` returns `ok`  

All logs are written to standard output.

## Terraform Configuration

Set values in `terraform/terraform.tfvars`. Example:

aws_region = "ap-south-1"
app_git_repo = "https://github.com/
<username>/<repo>.git"


Other defaults such as VPC CIDR blocks, subnet ranges and Auto Scaling settings are defined in `variables.tf`. These can be overridden in the same `terraform.tfvars` file if required.

## One Click Local Deployment

From the root of the repository:

Make the scripts executable.



chmod +x scripts/deploy.sh scripts/destroy.sh scripts/test.sh


Deploy the full stack.



./scripts/deploy.sh


After the apply step finishes, test the application.



./scripts/test.sh


The test script reads the Application Load Balancer DNS name from the Terraform output `alb_dns_name` and calls the endpoints at



http://<alb_dns>/
http://<alb_dns>/health


To remove the stack:



./scripts/destroy.sh


## GitHub Actions Deployment

Workflows are stored under `.github/workflows/`.

### deploy.yml

Runs on pushes to the `main` branch or when started manually.  
Steps include checkout, AWS credentials setup, `terraform init` and `terraform apply` inside the `terraform/` directory.

### destroy.yml

Optional manual workflow that runs `terraform destroy` in the same directory.

Before running these workflows, confirm that the AWS credentials are stored as repository secrets 
