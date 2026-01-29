# CloudedX Architecture Documentation

**Author:** theyashdhiman04

## System Architecture Overview

CloudedX implements a multi-tier architecture for Kubernetes cluster deployment and monitoring on AWS infrastructure.

## Infrastructure Layer

### Network Architecture

The platform creates a VPC-based network topology:

- **VPC**: Single VPC with CIDR 10.0.0.0/16
- **Internet Gateway**: Provides internet connectivity
- **Public Subnets**: Two subnets across different availability zones
  - Control Plane Subnet: 10.0.1.0/24 (AZ-1)
  - Worker Subnet: 10.0.2.0/24 (AZ-2)
- **Route Tables**: Public route table with default route to IGW
- **Security Groups**: Permissive security group allowing all traffic

### Compute Architecture

EC2 instances are provisioned across availability zones:

- **Control Plane Node**: Single t2.medium instance
  - Runs Kubernetes API server, etcd, controller manager, scheduler
  - Located in control plane subnet
  - Public IP for external access
  
- **Worker Nodes**: Two t2.medium instances
  - Run application workloads
  - Located in worker subnet
  - Public IPs for external access

## Kubernetes Layer

### Cluster Configuration

- **Kubernetes Version**: 1.32.0
- **CNI Plugin**: Calico for pod networking
- **Pod Subnet**: 192.168.0.0/16
- **Service Port Range**: 1024-1233

### Node Roles

**Control Plane:**
- Manages cluster state
- Schedules pods
- Exposes Kubernetes API
- Runs cluster-level controllers

**Worker Nodes:**
- Execute application workloads
- Run kubelet and kube-proxy
- Report node status to control plane

## Monitoring Layer

### Prometheus Stack

- **Metrics Collection**: Scrapes metrics from Kubernetes components
- **Storage**: Ephemeral (no persistent volumes)
- **Service Discovery**: Automatically discovers Kubernetes targets
- **Exposition**: NodePort service for external access

### Grafana Platform

- **Visualization**: Pre-configured dashboards for cluster monitoring
- **Data Source**: Connected to Prometheus
- **Authentication**: Basic auth with configurable credentials
- **Exposition**: NodePort service for external access

## Application Layer

### Sample Application

- **Deployment**: React-based web application
- **Replicas**: 2 instances for high availability
- **Service Type**: NodePort on port 1233
- **Purpose**: Demonstrates cluster functionality

## Data Flow

1. **Infrastructure Provisioning**: Terraform creates AWS resources
2. **Cluster Initialization**: kubeadm initializes Kubernetes cluster
3. **Node Joining**: Worker nodes join cluster via join tokens
4. **Monitoring Deployment**: Helm installs Prometheus and Grafana
5. **Application Deployment**: Sample app deployed via kubectl
6. **Metrics Collection**: Prometheus scrapes metrics from cluster
7. **Visualization**: Grafana queries Prometheus and displays dashboards

## Security Architecture

### Network Security

- Security groups control traffic flow
- Public subnets for internet-facing resources
- SSH key-based authentication for node access

### Cluster Security

- RBAC enabled by default
- Service account permissions configured
- Network policies can be applied (not included by default)

### Data Security

- EBS volumes encrypted at rest
- SSH keys stored securely
- No sensitive data in code repository

## Scalability Considerations

### Horizontal Scaling

- Worker nodes can be scaled by modifying Terraform count
- Application replicas can be increased via deployment manifests

### Vertical Scaling

- Instance types can be upgraded in variables.tf
- Resource limits can be adjusted in deployment manifests

## High Availability

### Current Implementation

- Single control plane (not HA)
- Two worker nodes for redundancy
- Applications can be scaled across nodes

### Production Recommendations

- Deploy multiple control plane nodes
- Use managed Kubernetes service (EKS)
- Implement persistent storage for Prometheus
- Add load balancers for service exposure
- Implement backup and disaster recovery

## Monitoring and Observability

### Metrics Collected

- Node resource utilization (CPU, memory, disk)
- Pod resource consumption
- Kubernetes API metrics
- Container runtime metrics
- Network metrics

### Dashboards

- Cluster overview
- Node metrics
- Pod metrics
- Application performance

## Deployment Workflow

1. **Terraform Apply**: Provisions AWS infrastructure
2. **SSH to Control Plane**: Configure and initialize cluster
3. **Join Workers**: Add worker nodes to cluster
4. **Install Helm**: Package manager installation
5. **Deploy Monitoring**: Prometheus and Grafana via Helm
6. **Configure Grafana**: Set up data sources and dashboards
7. **Deploy Applications**: Sample app and other workloads

## Maintenance and Operations

### Regular Tasks

- Monitor cluster health via Grafana
- Review Prometheus alerts
- Update Kubernetes components
- Rotate SSH keys periodically
- Review and optimize resource usage

### Backup Strategy

- Export Terraform state regularly
- Backup Kubernetes manifests
- Export Grafana dashboards
- Consider etcd backups for production

## Cost Optimization

### Current Configuration

- t2.medium instances (~$0.0416/hour each)
- No persistent storage costs
- Data transfer charges apply

### Optimization Tips

- Use spot instances for worker nodes
- Implement auto-scaling
- Schedule non-production clusters
- Use smaller instance types for development

## Future Enhancements

Potential improvements for CloudedX:

- Multi-AZ control plane deployment
- Persistent storage for Prometheus
- Integrated logging solution (Loki)
- Service mesh integration
- CI/CD pipeline automation
- Automated backup solutions
- Cost monitoring and alerts

---

**Documentation maintained by theyashdhiman04**
