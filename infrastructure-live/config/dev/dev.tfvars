# Set your real account, VPC and private subnet IDs before planning.
project = "platform"
account_id = "111111111111"
region = "us-east-1"
environment = "dev"
vpc_id = "vpc-REPLACE_ME"
private_subnet_ids = ["subnet-REPLACE_A", "subnet-REPLACE_B"]
kubernetes_version = "1.34"
endpoint_public_access = false
public_access_cidrs = []
node_capacity_type = "SPOT"
node_min_size = 1
node_desired_size = 2
node_max_size = 3
node_instance_types = ["m6i.large"]
