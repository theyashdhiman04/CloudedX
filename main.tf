# CloudedX - Main Infrastructure Configuration
# Author: theyashdhiman04
# Description: Core Terraform configuration for CloudedX Kubernetes monitoring platform

terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "CloudedX"
      ManagedBy   = "Terraform"
      Environment = var.environment
      Owner       = "theyashdhiman04"
    }
  }
}

# Deploy Network Infrastructure
# =============================
module "network" {
  source = "./modules/network"
  
  aws_region   = var.aws_region
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
}

# Deploy Compute Infrastructure
# ==============================
module "compute" {
  source = "./modules/compute"
  
  aws_region         = var.aws_region
  instance_type      = var.instance_type
  control_plane_subnet = module.network.control_plane_subnet_id
  worker_subnet      = module.network.worker_subnet_id
  security_group_id  = module.network.cluster_security_group_id
  subnet_cidr_one    = module.network.subnet_cidr_one
  subnet_cidr_two    = module.network.subnet_cidr_two
  ssh_public_key     = var.ssh_public_key_path
  ssh_private_key    = var.ssh_private_key_path
  project_name       = var.project_name
}
