# CloudedX Network Module
# Author: theyashdhiman04
# Description: VPC and networking resources for CloudedX platform

provider "aws" {
  region = var.aws_region
}

# Retrieve available availability zones
# ====================================
data "aws_availability_zones" "available" {
  state = "available"
}

# Create VPC for CloudedX cluster
# ================================
resource "aws_vpc" "cloudedx_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name        = "${var.project_name}-vpc"
    Description = "VPC for CloudedX Kubernetes cluster"
  }
}

# Create Internet Gateway
# =======================
resource "aws_internet_gateway" "cloudedx_igw" {
  vpc_id = aws_vpc.cloudedx_vpc.id
  
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Create public route table
# =========================
resource "aws_route_table" "cloudedx_public_rt" {
  vpc_id = aws_vpc.cloudedx_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudedx_igw.id
  }
  
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Create control plane subnet
# ============================
resource "aws_subnet" "control_plane_subnet" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = aws_vpc.cloudedx_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project_name}-control-plane-subnet"
    Type = "ControlPlane"
  }
}

# Create worker node subnet
# =========================
resource "aws_subnet" "worker_subnet" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id            = aws_vpc.cloudedx_vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project_name}-worker-subnet"
    Type = "Worker"
  }
}

# Associate control plane subnet with route table
# ===============================================
resource "aws_route_table_association" "control_plane_rta" {
  subnet_id      = aws_subnet.control_plane_subnet.id
  route_table_id = aws_route_table.cloudedx_public_rt.id
}

# Associate worker subnet with route table
# =========================================
resource "aws_route_table_association" "worker_rta" {
  subnet_id      = aws_subnet.worker_subnet.id
  route_table_id = aws_route_table.cloudedx_public_rt.id
}

# Create security group for cluster nodes
# ========================================
resource "aws_security_group" "cluster_sg" {
  name        = "${var.project_name}-cluster-sg"
  description = "Security group for CloudedX Kubernetes cluster nodes"
  vpc_id      = aws_vpc.cloudedx_vpc.id

  # Allow all inbound traffic (for Kubernetes and monitoring)
  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-cluster-sg"
  }
}
