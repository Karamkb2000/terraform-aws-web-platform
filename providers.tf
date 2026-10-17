provider "aws" {
  region = var.region

  default_tags {
    tags = {
        project = var.project
        Environment = var.environment
        ManagedBy = "Terraform"
    }
  }
}