# Reusable EKS module

Creates a private-endpoint EKS cluster, log group, cluster/node IAM roles, managed node group, core add-ons and OIDC provider. Public access requires explicit non-open CIDRs. Optional secrets envelope encryption requires a separately provisioned KMS key. Network/VPC/subnets, load balancers, and pipelines are out of scope.

This module has **no provider block and no backend block**. Deploy through the live repository pinned to a release tag. Inputs: `cluster_name`, `environment`, `vpc_id`, `private_subnet_ids`, `kubernetes_version`, endpoint settings, node sizing/capacity, logging, KMS and tags. Private subnets must exist and have network egress/endpoints for EKS nodes. IAM permission boundaries and additional workload roles must be reviewed for each account.

Example: `examples/basic/main.tf`. Run `terraform fmt -check -recursive`, `terraform init -backend=false`, `terraform validate`, `terraform test` (Terraform >= 1.11). Pin a tag on release and commit `.terraform.lock.hcl` generated on a supported platform.

## Next steps

Consider per-account OIDC CI roles, KMS key policy, EKS access entries, pod identity for add-ons and node CNI policies prior to production use. Review Kubernetes and EC2 AMI compatibility with AWS for each account/region.
