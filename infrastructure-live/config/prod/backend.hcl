# Replace placeholders with a separately bootstrapped S3 bucket and AWS account.
bucket = "REPLACE-prod-terraform-state"
region = "us-east-1"
key = "prod/eks/terraform.tfstate"
encrypt = true
use_lockfile = true
