# The live root consumes a versioned module and never points at a Git branch.
module "eks" {
  source = "git::https://github.com/YOUR-ORG/terraform-modules.git//eks?ref=v1.0.0"
  cluster_name = "${var.project}-${var.environment}-eks"
  environment = var.environment
  vpc_id = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  kubernetes_version = var.kubernetes_version
  endpoint_public_access = var.endpoint_public_access
  public_access_cidrs = var.public_access_cidrs
  node_capacity_type = var.node_capacity_type
  node_instance_types = var.node_instance_types
  node_min_size = var.node_min_size
  node_desired_size = var.node_desired_size
  node_max_size = var.node_max_size
  tags = { Project = var.project }
}
