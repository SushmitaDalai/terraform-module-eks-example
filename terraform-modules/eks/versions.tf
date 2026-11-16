# Pin Terraform and provider compatibility for the reusable EKS module.
terraform {
  required_version = ">= 1.11.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.40, < 7.0" }
    tls = { source = "hashicorp/tls", version = ">= 4.0, < 5.0" }
  }
}
