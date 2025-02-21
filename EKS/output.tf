output "cluster_id" {
  value = aws_eks_cluster.login_page.id
}

output "node_group_id" {
  value = aws_eks_node_group.login_page.id
}

output "vpc_id" {
  value = aws_vpc.login_page_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.login_page_subnet[*].id
}
