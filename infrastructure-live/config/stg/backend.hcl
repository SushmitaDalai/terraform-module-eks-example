# Replace placeholders with a separately bootstrapped S3 bucket and AWS account.
bucket = "REPLACE-stg-terraform-state"
region = "us-east-1"
key = "stg/eks/terraform.tfstate"
encrypt = true
use_lockfile = true
