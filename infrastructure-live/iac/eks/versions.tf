# Require Terraform 1.11+ and the AWS provider supported by the module.
terraform {
  required_version = ">= 1.11.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.40, < 7.0" } }
}
