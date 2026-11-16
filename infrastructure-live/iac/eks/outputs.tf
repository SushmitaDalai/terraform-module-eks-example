# Publish values that can be used by cross-component dependencies.
output "cluster_name" { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "oidc_provider_arn" { value = module.eks.oidc_provider_arn }
output "node_role_arn" { value = module.eks.node_role_arn }
output "kubeconfig_command" { value = module.eks.kubeconfig_command }
