# terraform-aws-web-platform

A modular, two-AZ AWS web platform to build with Terraform.

![Architecture](architecture.png)

## What you build
A three-tier platform provisioned from one root module and five child modules:

- `modules/network` — VPC, public / private app / database subnets, IGW, NAT, route tables
- `modules/security` — ALB, web, and database security groups
- `modules/storage` — S3 bucket (versioned, encrypted) + IAM instance role
- `modules/data` — RDS PostgreSQL + DB subnet group
- `modules/web` — launch template, ALB, target group, listener, Auto Scaling Group (CPU target tracking)

Traffic: `Users → Internet Gateway → ALB → EC2 (private) → RDS`, outbound via NAT, S3 via IAM role.

## Your task
All files are present but empty. Fill them in so the stack provisions cleanly.

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Open the `alb_dns_name` output in a browser. Tear down with `terraform destroy`.

## Notes
- Needs AWS credentials (`aws configure`) and Terraform >= 1.6.
- The NAT gateway, ALB, and RDS cost money hourly — run `terraform destroy` when done.
- `backend.tf.example` shows optional S3 + DynamoDB remote state.
