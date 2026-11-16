# Replace placeholders with a separately bootstrapped S3 bucket and AWS account.
bucket = "REPLACE-dev-terraform-state"
region = "us-east-1"
key = "dev/eks/terraform.tfstate"
encrypt = true
use_lockfile = true
