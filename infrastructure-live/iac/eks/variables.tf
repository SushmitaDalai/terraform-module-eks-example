# Set these account-specific values with one environment tfvars file.
variable "project" { type = string
 default = "platform" }
variable "account_id" {
  type = string
  validation { condition = can(regex("^[0-9]{12}$", var.account_id))
 error_message = "account_id must be 12 digits." }
}
variable "region" { type = string }
variable "environment" {
  type = string
  validation { condition = contains(["dev", "stg", "prod"], var.environment)
 error_message = "environment must be dev, stg, or prod." }
}
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "kubernetes_version" { type = string }
variable "endpoint_public_access" { type = bool
 default = false }
variable "public_access_cidrs" { type = list(string)
 default = [] }
variable "node_capacity_type" { type = string
 default = "ON_DEMAND" }
variable "node_min_size" { type = number
 default = 2 }
variable "node_desired_size" { type = number
 default = 2 }
variable "node_max_size" { type = number
 default = 4 }
variable "node_instance_types" { type = list(string)
 default = ["m6i.large"] }
