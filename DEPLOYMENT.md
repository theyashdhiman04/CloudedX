# CloudedX Deployment Guide

**Author:** theyashdhiman04

## Overview

This guide provides step-by-step instructions for deploying the CloudedX Kubernetes monitoring platform on AWS using Terraform.

## Prerequisites

- AWS account with appropriate permissions
- Terraform >= 1.5.0 installed
- AWS CLI configured with credentials
- SSH key pair generated (`~/.ssh/cloudedx` and `~/.ssh/cloudedx.pub`)

## Infrastructure Deployment

### Step 1: Configure SSH Keys

Update the SSH key paths in `variables.tf` if your keys are located elsewhere:

```hcl
variable "ssh_public_key_path" {
  default = "~/.ssh/cloudedx.pub"
}

variable "ssh_private_key_path" {
  default = "~/.ssh/cloudedx"
}
```

### Step 2: Initialize Terraform

```bash
terraform init
```

### Step 3: Review Deployment Plan

```bash
terraform plan
```

### Step 4: Deploy Infrastructure

```bash
terraform apply
```

After successful deployment, note the output values:
- `control_plane_public_ip`: IP address of the Kubernetes control plane
- `worker_nodes_public_ips`: List of worker node IP addresses

## Kubernetes Cluster Setup

### Step 1: Connect to Control Plane Node

```bash
ssh -i ~/.ssh/cloudedx ec2-user@<control_plane_public_ip>
```

### Step 2: System Configuration

Run the following commands to prepare the system:

```bash
# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Load kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
```

### Step 3: Install Container Runtime

```bash
# Update system
sudo yum update -y

# Install containerd
sudo yum install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl enable --now containerd
sudo systemctl restart containerd
```

### Step 4: Install Kubernetes Components

```bash
# Add Kubernetes repository
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

# Set SELinux to permissive
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Install Kubernetes components
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
```

### Step 5: Initialize Cluster

```bash
# Copy cluster configuration
scp cluster-config.yml ec2-user@<control_plane_ip>:~/

# Initialize cluster
sudo kubeadm init --config cluster-config.yml --ignore-preflight-errors=all

# Configure kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Step 6: Install Network Plugin

```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

Wait a few minutes, then verify:

```bash
kubectl get nodes
```

### Step 7: Join Worker Nodes

On the control plane, generate join command:

```bash
kubeadm token create --print-join-command
```

SSH into each worker node and run the generated join command with `sudo`.

## Monitoring Stack Deployment

### Step 1: Install Helm

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Grant permissions
kubectl --namespace=kube-system create clusterrolebinding add-on-cluster-admin \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:default
```

### Step 2: Deploy Prometheus

```bash
# Add repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Deploy Prometheus
helm install -f prometheus-config.yml prometheus prometheus-community/kube-prometheus-stack

# Expose via NodePort
kubectl expose service prometheus-kube-prometheus-prometheus --type=NodePort --target-port=9090 --name=prometheus-np
```

### Step 3: Deploy Grafana

```bash
# Add repository
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Deploy Grafana
helm install -f grafana-config.yml grafana grafana/grafana

# Expose via NodePort
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-np
```

### Step 4: Configure Grafana Data Source

1. Access Grafana UI: `http://<node_ip>:<nodeport>/login`
2. Login with credentials from `grafana-config.yml`
3. Navigate to Configuration > Data Sources > Add data source
4. Select Prometheus
5. URL: `http://prometheus-kube-prometheus-prometheus.default.svc.cluster.local:9090`
6. Click Save & Test

### Step 5: Import Dashboards

In Grafana:
1. Go to Dashboards > Import
2. Import dashboard ID: `10000` (Kubernetes Cluster Monitoring)
3. Import dashboard ID: `13770` (Kubernetes Pod Monitoring)

## Sample Application Deployment

Deploy the sample application:

```bash
kubectl apply -f sample-app-deployment.yml
```

Access the application at `http://<node_ip>:1233`

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Troubleshooting

### Nodes Not Ready

Check node status:
```bash
kubectl get nodes
kubectl describe node <node-name>
```

### Pods Not Starting

Check pod status:
```bash
kubectl get pods --all-namespaces
kubectl describe pod <pod-name>
```

### Service Not Accessible

Verify service and endpoints:
```bash
kubectl get svc
kubectl get endpoints
```
