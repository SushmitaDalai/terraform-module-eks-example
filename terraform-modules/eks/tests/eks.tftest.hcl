# Verify module input handling using mocked providers and no AWS credentials.
mock_provider "aws" {}
mock_provider "tls" {}
run "secure_defaults" {
  command = plan
  variables {
    cluster_name = "demo-dev-eks"
    environment = "dev"
    vpc_id = "vpc-0123456789abcdef0"
    private_subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    kubernetes_version = "1.34"
  }
  assert { condition = aws_eks_cluster.this.vpc_config[0].endpoint_private_access == true
 error_message = "Private EKS endpoint must always be enabled." }
  assert { condition = aws_eks_cluster.this.vpc_config[0].endpoint_public_access == false
 error_message = "Public endpoint should default to disabled." }
  assert { condition = aws_eks_node_group.managed.capacity_type == "ON_DEMAND"
 error_message = "Default nodes should use on-demand capacity." }
}
run "invalid_public_access" {
  command = plan
  variables {
    cluster_name = "demo-dev-eks"
    environment = "dev"
    vpc_id = "vpc-0123456789abcdef0"
    private_subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    kubernetes_version = "1.34"
    endpoint_public_access = true
  }
  expect_failures = [aws_eks_cluster.this]
}
run "invalid_node_sizes" {
  command = plan
  variables {
    cluster_name = "demo-dev-eks"
    environment = "dev"
    vpc_id = "vpc-0123456789abcdef0"
    private_subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    kubernetes_version = "1.34"
    node_min_size = 4
    node_desired_size = 2
    node_max_size = 3
  }
  expect_failures = [aws_eks_node_group.managed]
}
