# Tag everything and refuse to plan against the wrong AWS account.
provider "aws" {
  region = var.region
  allowed_account_ids = [var.account_id]
  default_tags { tags = { Project = var.project, Environment = var.environment, Component = "eks", ManagedBy = "Terraform" } }
}
