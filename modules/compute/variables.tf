# CloudedX Compute Module - Variables
# Author: theyashdhiman04

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for Kubernetes nodes"
  type        = string
  default     = "t2.medium"
}

variable "ssh_public_key" {
  description = "Path to SSH public key file"
  type        = string
}

variable "ssh_private_key" {
  description = "Path to SSH private key file"
  type        = string
}

variable "control_plane_subnet" {
  description = "Subnet ID for control plane node"
  type        = string
}

variable "worker_subnet" {
  description = "Subnet ID for worker nodes"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for cluster nodes"
  type        = string
}

variable "subnet_cidr_one" {
  description = "CIDR block of control plane subnet"
  type        = string
}

variable "subnet_cidr_two" {
  description = "CIDR block of worker subnet"
  type        = string
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "cloudedx"
}
