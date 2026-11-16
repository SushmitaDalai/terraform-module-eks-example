# EKS live infrastructure

This repository contains exactly one Terraform root for EKS. The reusable module is a separate repository `terraform-modules`, referenced by an immutable version tag (`v1.0.0`); replace `YOUR-ORG` with the GitHub organization and publish the tag before initializing. Configure only `config/<env>/backend.hcl` and `config/<env>/<env>.tfvars` per environment.

## One-time S3 backend bootstrap (AWS CLI)

These are one-time **plain AWS CLI commands**, not an automated shell script. Run with the correct AWS credentials in **each environment's AWS account**. Replace the bucket and region, and ensure the name is globally unique. For regions other than `us-east-1`, add `--create-bucket-configuration LocationConstraint=<REGION>`.

```bash
aws s3api create-bucket --bucket REPLACE-dev-terraform-state --region us-east-1
aws s3api put-bucket-versioning --bucket REPLACE-dev-terraform-state --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket REPLACE-dev-terraform-state --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
aws s3api put-public-access-block --bucket REPLACE-dev-terraform-state --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

Apply analogous commands for `stg` and `prod`, using their account credentials and bucket names. S3 `use_lockfile = true` provides native locking, **no DynamoDB table**. Protect and audit S3 access with per-account IAM policies.

## Initialize and plan

```bash
terraform init -reconfigure -backend-config=config/dev/backend.hcl
terraform fmt -check -recursive
terraform validate
terraform plan -var-file=config/dev/dev.tfvars
```

Repeat with `stg` / `prod` only after changing AWS credentials and initializing with the matching backend file. Never reuse state across environments. Do not use CLI workspaces for environments. Public EKS access is disabled by default. Nodes need private-subnet connectivity (NAT or relevant VPC endpoints), and the cluster is reached from a VPC-connected network. **No real apply is performed by this deliverable.**

## Prerequisites / next steps

1. Create both GitHub repositories and tag the module `v1.0.0`; commit provider lockfiles generated with Terraform.
2. Create the versioned/encrypted/public-blocked S3 state bucket in each account; ensure GitHub Actions / Jenkins OIDC roles and least-privilege IAM policies are configured separately.
3. Supply actual account IDs, subnet IDs and VPC ID, confirm EKS version/AMI support and private subnet networking.
4. Build CI pipelines, cross-component `terraform_remote_state` consumers, workload access entries, and any production-specific policies in a later section.
