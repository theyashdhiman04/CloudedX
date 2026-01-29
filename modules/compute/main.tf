# CloudedX Compute Module
# Author: theyashdhiman04
# Description: EC2 instances for Kubernetes cluster nodes

provider "aws" {
  region = var.aws_region
}

# Retrieve latest Amazon Linux 2 AMI
# ===================================
data "aws_ssm_parameter" "amazon_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create SSH key pair for cluster access
# ======================================
resource "aws_key_pair" "cluster_key" {
  key_name   = "${var.project_name}-cluster-key"
  public_key = file(var.ssh_public_key)
  
  tags = {
    Name = "${var.project_name}-ssh-key"
  }
}

# Create Kubernetes Control Plane Instance
# =========================================
resource "aws_instance" "control_plane" {
  instance_type          = var.instance_type
  ami                    = data.aws_ssm_parameter.amazon_linux_ami.value
  key_name               = aws_key_pair.cluster_key.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.control_plane_subnet
  associate_public_ip_address = true
  
  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }
  
  tags = {
    Name        = "${var.project_name}-control-plane"
    Role        = "ControlPlane"
    Component   = "Kubernetes"
  }
  
  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname ${var.project_name}-control-plane
  EOF
}

# Create Kubernetes Worker Node Instances
# =======================================
resource "aws_instance" "worker_nodes" {
  count                  = 2
  instance_type          = var.instance_type
  ami                    = data.aws_ssm_parameter.amazon_linux_ami.value
  key_name               = aws_key_pair.cluster_key.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.worker_subnet
  associate_public_ip_address = true
  
  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }
  
  tags = {
    Name        = "${var.project_name}-worker-${count.index}"
    Role        = "Worker"
    Component   = "Kubernetes"
    NodeIndex   = count.index
  }
  
  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname ${var.project_name}-worker-${count.index}
  EOF
}
