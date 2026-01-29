# CloudedX Compute Module - Outputs
# Author: theyashdhiman04

output "control_plane_public_ip" {
  description = "Public IP address of the control plane node"
  value       = aws_instance.control_plane.public_ip
}

output "control_plane_private_ip" {
  description = "Private IP address of the control plane node"
  value       = aws_instance.control_plane.private_ip
}

output "worker_nodes_public_ips" {
  description = "List of public IP addresses for worker nodes"
  value       = aws_instance.worker_nodes[*].public_ip
}

output "worker_nodes_private_ips" {
  description = "List of private IP addresses for worker nodes"
  value       = aws_instance.worker_nodes[*].private_ip
}

output "key_pair_name" {
  description = "Name of the created SSH key pair"
  value       = aws_key_pair.cluster_key.key_name
}
