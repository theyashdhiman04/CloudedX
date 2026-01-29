# CloudedX Network Module - Outputs
# Author: theyashdhiman04

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.cloudedx_vpc.id
}

output "control_plane_subnet_id" {
  description = "ID of the control plane subnet"
  value       = aws_subnet.control_plane_subnet.id
}

output "worker_subnet_id" {
  description = "ID of the worker node subnet"
  value       = aws_subnet.worker_subnet.id
}

output "cluster_security_group_id" {
  description = "ID of the cluster security group"
  value       = aws_security_group.cluster_sg.id
}

output "subnet_cidr_one" {
  description = "CIDR block of control plane subnet"
  value       = aws_subnet.control_plane_subnet.cidr_block
}

output "subnet_cidr_two" {
  description = "CIDR block of worker subnet"
  value       = aws_subnet.worker_subnet.cidr_block
}
