# Set your real account, VPC and private subnet IDs before planning.
project = "platform"
account_id = "222222222222"
region = "us-east-1"
environment = "stg"
vpc_id = "vpc-REPLACE_ME"
private_subnet_ids = ["subnet-REPLACE_A", "subnet-REPLACE_B"]
kubernetes_version = "1.34"
endpoint_public_access = false
public_access_cidrs = []
node_capacity_type = "ON_DEMAND"
node_min_size = 2
node_desired_size = 2
node_max_size = 4
node_instance_types = ["m6i.large"]
