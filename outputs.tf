# CloudedX - Output Definitions
# Author: theyashdhiman04

output "control_plane_public_ip" {
  description = "Public IP address of the Kubernetes control plane node"
  value       = module.compute.control_plane_public_ip
}

output "worker_nodes_public_ips" {
  description = "List of public IP addresses for Kubernetes worker nodes"
  value       = module.compute.worker_nodes_public_ips
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}

output "cluster_info" {
  description = "Cluster connection information"
  value = {
    control_plane_ip = module.compute.control_plane_public_ip
    worker_ips       = module.compute.worker_nodes_public_ips
    ssh_command      = "ssh -i ${var.ssh_private_key_path} ec2-user@${module.compute.control_plane_public_ip}"
  }
}
