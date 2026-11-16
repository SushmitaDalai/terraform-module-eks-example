# Validate module inputs before creating any AWS infrastructure.
variable "cluster_name" { type = string }
variable "environment" {
  type = string
  validation { condition = contains(["dev", "stg", "prod"], var.environment)
 error_message = "environment must be dev, stg or prod." }
}
variable "vpc_id" { type = string }
variable "private_subnet_ids" {
  type = list(string)
  validation { condition = length(distinct(var.private_subnet_ids)) >= 2
 error_message = "At least two distinct private subnet IDs are required." }
}
variable "kubernetes_version" {
  type = string
  validation { condition = can(regex("^1\.(3[4-9]|[4-9][0-9])$", var.kubernetes_version))
 error_message = "Use a supported Kubernetes version 1.34 or later; confirm AWS region support." }
}
variable "endpoint_public_access" { type = bool
 default = false }
variable "public_access_cidrs" {
  type = list(string)
 default = []
  validation { condition = alltrue([for c in var.public_access_cidrs : can(cidrhost(c, 0))])
 error_message = "All public access CIDRs must be valid." }
}
variable "node_ami_type" { type = string
 default = "AL2023_x86_64_STANDARD" }
variable "node_instance_types" { type = list(string)
 default = ["m6i.large"] }
variable "node_capacity_type" {
  type = string
 default = "ON_DEMAND"
  validation { condition = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
 error_message = "Capacity type must be ON_DEMAND or SPOT." }
}
variable "node_min_size" { type = number
 default = 2 }
variable "node_desired_size" { type = number
 default = 2 }
variable "node_max_size" { type = number
 default = 4 }
variable "log_retention_days" { type = number
 default = 30 }
variable "enable_secrets_encryption" { type = bool
 default = false }
variable "kms_key_arn" { type = string
 default = null }
variable "tags" { type = map(string)
 default = {} }
