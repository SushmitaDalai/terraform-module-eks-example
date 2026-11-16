# Demonstrate module input values without deploying infrastructure.
module "eks" {
  source = "../../"
  cluster_name = "demo-dev-eks"
  environment = "dev"
  vpc_id = "vpc-0123456789abcdef0"
  private_subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
  kubernetes_version = "1.34"
  endpoint_public_access = false
  node_min_size = 2
  node_desired_size = 2
  node_max_size = 3
  tags = { Project = "demo" }
}
