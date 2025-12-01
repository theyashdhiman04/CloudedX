# CloudedX

**A comprehensive Kubernetes observability platform built with Terraform, Prometheus, and Grafana**

**Author:** Yash Dhiman (`theyashdhiman04`)

## Overview

CloudedX is an Infrastructure-as-Code solution that automates the deployment of a production-ready Kubernetes monitoring stack on AWS. The platform combines Terraform for infrastructure provisioning, Kubernetes for orchestration, and Prometheus + Grafana for comprehensive observability.

## Features

- **Automated Infrastructure**: Complete AWS infrastructure provisioning using Terraform
- **Kubernetes Cluster**: Self-managed Kubernetes cluster with control plane and worker nodes
- **Monitoring Stack**: Integrated Prometheus for metrics collection
- **Visualization**: Grafana dashboards for real-time monitoring and alerting
- **Modular Design**: Clean separation of network and compute modules
- **Production Ready**: Security groups, encrypted volumes, and best practices

## Architecture

CloudedX deploys the following components:

- **VPC**: Isolated network environment with public subnets
- **Control Plane**: Single Kubernetes master node for cluster management
- **Worker Nodes**: Two worker nodes for application workloads
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboard platform
- **Sample Application**: Demo application for testing cluster functionality

## Prerequisites

Before deploying CloudedX, ensure you have:

- AWS account with appropriate IAM permissions
- Terraform >= 1.5.0 installed
- AWS CLI configured with valid credentials
- SSH key pair generated (`~/.ssh/cloudedx` and `~/.ssh/cloudedx.pub`)
- Basic knowledge of Kubernetes and Terraform

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/theyashdhiman04/CloudedX.git
cd CloudedX
```

### 2. Configure SSH Keys

Ensure your SSH keys are in place:

```bash
# Generate SSH key pair if needed
ssh-keygen -t rsa -b 4096 -f ~/.ssh/cloudedx -N ""
```

Update `variables.tf` if your keys are in a different location.

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review deployment plan
terraform plan

# Deploy infrastructure
terraform apply
```

After deployment completes, note the output values for the control plane and worker node IP addresses.

### 4. Set Up Kubernetes Cluster

Follow the detailed instructions in [DEPLOYMENT.md](DEPLOYMENT.md) to:
- Configure the control plane node
- Join worker nodes to the cluster
- Deploy the monitoring stack
- Configure Grafana dashboards

## Project Structure

```
CloudedX/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── outputs.tf              # Output definitions
├── cluster-config.yml      # Kubernetes cluster configuration
├── prometheus-config.yml   # Prometheus Helm values
├── grafana-config.yml      # Grafana Helm values
├── sample-app-deployment.yml # Sample application manifest
├── DEPLOYMENT.md           # Detailed deployment guide
├── modules/
│   ├── network/           # VPC and networking module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── compute/           # EC2 instances module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md              # This file
```

## Configuration

### Variables

Key variables you can customize in `variables.tf`:

- `aws_region`: AWS region for deployment (default: `us-east-1`)
- `instance_type`: EC2 instance type (default: `t2.medium`)
- `vpc_cidr`: VPC CIDR block (default: `10.0.0.0/16`)
- `environment`: Environment name (default: `dev`)

### Kubernetes Configuration

The cluster is configured via `cluster-config.yml`:
- Kubernetes version: 1.32.0
- Pod subnet: 192.168.0.0/16
- NodePort range: 1024-1233

### Monitoring Configuration

- **Prometheus**: Configured via `prometheus-config.yml`
- **Grafana**: Configured via `grafana-config.yml` (default password: `CloudedX2024!`)

## Accessing Services

After deployment, access services using NodePort:

- **Sample Application**: `http://<node-ip>:1233`
- **Prometheus**: `http://<node-ip>:<prometheus-nodeport>`
- **Grafana**: `http://<node-ip>:<grafana-nodeport>`

To find NodePort values:

```bash
kubectl get svc
```

## Monitoring Dashboards

CloudedX includes pre-configured Grafana dashboards:

1. **Kubernetes Cluster Monitoring** (Dashboard ID: 10000)
   - Cluster overview metrics
   - Node resource utilization
   - Pod distribution

2. **Kubernetes Pod Monitoring** (Dashboard ID: 13770)
   - Pod-level metrics
   - Container resource usage
   - Application performance

Import these dashboards through the Grafana UI after configuring the Prometheus data source.

## Security Considerations

- Security groups allow all traffic (0.0.0.0/0) for simplicity
- **Production deployments should restrict access** to specific IP ranges
- SSH keys are required for node access
- EBS volumes are encrypted
- Consider implementing network policies for pod-to-pod communication

## Cost Optimization

- Uses `t2.medium` instances by default (can be adjusted)
- No persistent volumes for Prometheus (data lost on pod restart)
- **Important**: Destroy resources when not in use to avoid charges

## Troubleshooting

### Infrastructure Issues

- Verify AWS credentials: `aws sts get-caller-identity`
- Check Terraform state: `terraform show`
- Review AWS console for resource status

### Kubernetes Issues

- Check node status: `kubectl get nodes`
- View pod logs: `kubectl logs <pod-name>`
- Describe resources: `kubectl describe <resource-type> <resource-name>`

### Monitoring Issues

- Verify Prometheus targets: Access Prometheus UI > Status > Targets
- Check Grafana data source connection
- Review Helm release status: `helm list`

## Cleanup

To destroy all resources and avoid AWS charges:

```bash
terraform destroy
```

**Warning**: This will permanently delete all resources created by CloudedX.

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is open source and available under the MIT License.

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- GitHub: `@theyashdhiman04`

## Acknowledgments

CloudedX leverages the following open-source technologies:
- [Terraform](https://www.terraform.io/)
- [Kubernetes](https://kubernetes.io/)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [Calico](https://www.tigera.io/project-calico/)

---

**Maintained by Yash Dhiman**
