# Expose the EKS identifiers needed by applications and other stacks.
output "cluster_name" { value = aws_eks_cluster.this.name }
output "cluster_endpoint" { value = aws_eks_cluster.this.endpoint }
output "oidc_provider_arn" { value = aws_iam_openid_connect_provider.cluster.arn }
output "node_role_arn" { value = aws_iam_role.nodes.arn }
output "kubeconfig_command" { value = "aws eks update-kubeconfig --name ${aws_eks_cluster.this.name} --region ${data.aws_region.current.name}" }
data "aws_region" "current" {}
