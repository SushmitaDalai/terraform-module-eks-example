# Create the EKS cluster, encrypted logs, IAM roles, add-ons and a managed node group.
locals {
  tags = merge(var.tags, { Environment = var.environment, Component = "eks", ManagedBy = "Terraform" })
}
resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_days
  tags              = local.tags
}
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "eks.amazonaws.com" }, Action = "sts:AssumeRole" }] })
  tags = local.tags
}
resource "aws_iam_role_policy_attachment" "cluster" {
  role = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role" "nodes" {
  name = "${var.cluster_name}-nodes"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" }, Action = "sts:AssumeRole" }] })
  tags = local.tags
}
resource "aws_iam_role_policy_attachment" "nodes" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])
  role = aws_iam_role.nodes.name
  policy_arn = each.value
}
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.kubernetes_version
  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.endpoint_public_access ? var.public_access_cidrs : null
  }
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  dynamic "encryption_config" {
    for_each = var.enable_secrets_encryption ? [1] : []
    content {
      provider { key_arn = var.kms_key_arn }
      resources = ["secrets"]
    }
  }
  access_config { authentication_mode = "API_AND_CONFIG_MAP" }
  tags = local.tags
  depends_on = [aws_iam_role_policy_attachment.cluster, aws_cloudwatch_log_group.cluster]
  lifecycle {
    precondition { condition = !var.endpoint_public_access || length(var.public_access_cidrs) > 0
 error_message = "Public endpoint requires explicit public_access_cidrs." }
    precondition { condition = var.enable_secrets_encryption == (var.kms_key_arn != null && var.kms_key_arn != "")
 error_message = "Supply kms_key_arn exactly when secrets encryption is enabled." }
    precondition { condition = !var.endpoint_public_access || !contains(var.public_access_cidrs, "0.0.0.0/0")
 error_message = "Unrestricted public endpoint is forbidden." }
  }
}
resource "aws_eks_node_group" "managed" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-managed"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.private_subnet_ids
  ami_type        = var.node_ami_type
  instance_types  = var.node_instance_types
  capacity_type   = var.node_capacity_type
  scaling_config { min_size = var.node_min_size
 desired_size = var.node_desired_size
 max_size = var.node_max_size }
  update_config { max_unavailable = 1 }
  tags = local.tags
  depends_on = [aws_iam_role_policy_attachment.nodes]
  lifecycle {
    precondition { condition = var.node_min_size >= 0 && var.node_max_size >= var.node_min_size && var.node_desired_size >= var.node_min_size && var.node_desired_size <= var.node_max_size
 error_message = "Node min <= desired <= max and min >= 0 required." }
  }
}
resource "aws_eks_addon" "managed" {
  for_each = toset(["vpc-cni", "kube-proxy", "coredns"])
  cluster_name = aws_eks_cluster.this.name
  addon_name = each.value
  resolve_conflicts_on_update = "PRESERVE"
  depends_on = [aws_eks_node_group.managed]
  tags = local.tags
}
# The OIDC provider allows IAM roles for service accounts without static credentials.
data "tls_certificate" "oidc" { url = aws_eks_cluster.this.identity[0].oidc[0].issuer }
resource "aws_iam_openid_connect_provider" "cluster" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
  tags = local.tags
}
