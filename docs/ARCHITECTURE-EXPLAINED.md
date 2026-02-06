# Complete System Architecture - DevOps Capstone Project

## 🎯 Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          YOUR LOCAL MACHINE                                  │
│                                                                              │
│  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐             │
│  │   Terraform  │      │   kubectl    │      │     Git      │             │
│  │    (IaC)     │      │    (K8s)     │      │   (Source)   │             │
│  └──────┬───────┘      └──────┬───────┘      └──────┬───────┘             │
│         │                     │                      │                      │
└─────────┼─────────────────────┼──────────────────────┼──────────────────────┘
          │                     │                      │
          │                     │                      │
          ▼                     │                      ▼
┌─────────────────────┐         │           ┌─────────────────────┐
│   AWS S3 + DynamoDB │         │           │   GitHub/GitLab     │
│  (Terraform State)  │         │           │   (Code Repo)       │
└─────────────────────┘         │           └──────────┬──────────┘
          │                     │                      │
          │                     │                      │ Webhook/Poll
          ▼                     │                      │
┌─────────────────────────────────────────────────────┼──────────────────────┐
│                           AWS CLOUD                 │                       │
│                                                     ▼                       │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │                    EC2 Instance (Jenkins Server)                      │  │
│  │  ┌────────────────────────────────────────────────────────────────┐  │  │
│  │  │                      Jenkins Installed                         │  │  │
│  │  │                                                                 │  │  │
│  │  │  Tools Required:                                               │  │  │
│  │  │  ✅ Docker         (for building images)                       │  │  │
│  │  │  ✅ AWS CLI       (for ECR, EKS access)                       │  │  │
│  │  │  ✅ kubectl       (for K8s deployment)                        │  │  │
│  │  │  ✅ Terraform     (for infra provisioning - OPTIONAL)         │  │  │
│  │  │  ✅ Git           (for code checkout)                         │  │  │
│  │  │                                                                 │  │  │
│  │  │  Jenkins Pipelines:                                            │  │  │
│  │  │  1. Infrastructure Pipeline (Terraform - OPTIONAL)             │  │  │
│  │  │  2. CI Pipeline (Build Docker images)                         │  │  │
│  │  │  3. CD Pipeline (Deploy to K8s)                               │  │  │
│  │  └────────────────────────────────────────────────────────────────┘  │  │
│  └───────┬──────────────────────────────┬─────────────────────────────────┘  │
│          │                              │                                    │
│          │ (Push Images)                │ (Deploy to K8s)                   │
│          ▼                              ▼                                    │
│  ┌──────────────────┐         ┌────────────────────────────────────────┐   │
│  │   AWS ECR        │         │         AWS EKS Cluster                │   │
│  │  (Container      │         │  ┌──────────────────────────────────┐  │   │
│  │   Registry)      │◄────────┤  │      VPC (10.0.0.0/16)          │  │   │
│  │                  │ Pull    │  │                                  │  │   │
│  │  Repositories:   │ Images  │  │  ┌────────────────────────────┐ │  │   │
│  │  ✓ frontend      │         │  │  │  Public Subnets (2 AZs)    │ │  │   │
│  │  ✓ backend       │         │  │  │  - 10.0.1.0/24            │ │  │   │
│  │  ✓ admin         │         │  │  │  - 10.0.2.0/24            │ │  │   │
│  └──────────────────┘         │  │  │  [Internet Gateway]        │ │  │   │
│                                │  │  └────────────────────────────┘ │  │   │
│                                │  │                                  │  │   │
│                                │  │  ┌────────────────────────────┐ │  │   │
│                                │  │  │  Private Subnets (2 AZs)   │ │  │   │
│                                │  │  │  - 10.0.10.0/24           │ │  │   │
│                                │  │  │  - 10.0.11.0/24           │ │  │   │
│                                │  │  │  [NAT Gateway]             │ │  │   │
│                                │  │  │                            │ │  │   │
│                                │  │  │  ┌──────────────────────┐ │ │  │   │
│                                │  │  │  │  EKS Worker Nodes    │ │ │  │   │
│                                │  │  │  │  (2x t3.medium EC2)  │ │ │  │   │
│                                │  │  │  │                      │ │ │  │   │
│                                │  │  │  │  Pods:               │ │ │  │   │
│                                │  │  │  │  ✓ MongoDB          │ │ │  │   │
│                                │  │  │  │  ✓ Backend (Node.js)│ │ │  │   │
│                                │  │  │  │  ✓ Frontend (React) │ │ │  │   │
│                                │  │  │  │  ✓ Admin (React)    │ │ │  │   │
│                                │  │  │  └──────────────────────┘ │ │  │   │
│                                │  │  └────────────────────────────┘ │  │   │
│                                │  └──────────────────────────────────┘  │   │
│                                │                                        │   │
│                                │  ┌──────────────────────────────────┐ │   │
│                                │  │     Ingress Load Balancer        │ │   │
│                                │  │  (AWS Network Load Balancer)     │ │   │
│                                │  └──────────────┬───────────────────┘ │   │
│                                └─────────────────┼─────────────────────┘   │
└──────────────────────────────────────────────────┼─────────────────────────┘
                                                   │
                                                   │ (Public Access)
                                                   ▼
                                        ┌────────────────────┐
                                        │       Users        │
                                        │   (Web Browser)    │
                                        └────────────────────┘
```

---

## 📋 Component Breakdown

### 1. **Your Existing Jenkins Server (EC2)**

**What it is:**
- An EC2 instance you've already created
- Has Jenkins installed and running
- Accessible via browser (http://jenkins-ip:8080)

**What it needs:**
- ✅ Docker (to build images)
- ✅ AWS CLI (to push to ECR, configure kubectl)
- ✅ kubectl (to deploy to Kubernetes)
- ✅ Git (to pull code from repo)
- ⚠️ Terraform (OPTIONAL - only if running infra from Jenkins)

**Purpose of jenkins-setup.yml:**
- The Ansible playbook installs these tools **IF NOT ALREADY PRESENT**
- **YOU CAN SKIP THIS** if your Jenkins already has these tools
- It was created to fulfill Sprint 3 requirement (Ansible for config management)
- Think of it as a "nice to have" for automation, not mandatory

**Do you need a new Jenkins?**
- **NO!** Use your existing Jenkins server
- Just verify it has the required tools installed

---

### 2. **AWS ECR (Container Registry)**

**What you already have:**
- ✅ ECR repositories created
- ✅ Docker images already pushed (frontend, backend, admin)

**How it's used:**
- Jenkins CI pipeline builds new images → pushes to ECR
- EKS pulls images from ECR when deploying pods
- Your existing images can be used directly!

**Repository naming:**
```
<account-id>.dkr.ecr.eu-west-2.amazonaws.com/jatinggg-shopnow/frontend:latest
<account-id>.dkr.ecr.eu-west-2.amazonaws.com/jatinggg-shopnow/backend:latest
<account-id>.dkr.ecr.eu-west-2.amazonaws.com/jatinggg-shopnow/admin:latest
```

---

### 3. **Terraform State (S3 + DynamoDB)**

**Current Configuration:**
```hcl
# In provider.tf
terraform {
  backend "s3" {
    bucket         = "jatin-s3-shopnow-tfstate"
    key            = "terraform/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "jatin-shopnow-statelock"
  }
}
```

**Your Question: "They might have existing files. How to overwrite?"**

**Option 1: Use Different State Key (RECOMMENDED)**
```hcl
# Change the key to a new path
backend "s3" {
  bucket = "jatin-s3-shopnow-tfstate"
  key    = "eks-capstone/terraform.tfstate"  # NEW KEY
  region = "eu-west-2"
  dynamodb_table = "jatin-shopnow-statelock"
}
```
**Benefit:** Keeps old state intact, new deployment is independent

**Option 2: Delete Old State (CAREFUL!)**
```bash
# List current state files
aws s3 ls s3://jatin-s3-shopnow-tfstate/terraform/ --recursive

# Delete old state (ONLY if you want to start fresh)
aws s3 rm s3://jatin-s3-shopnow-tfstate/terraform/terraform.tfstate

# DynamoDB locks auto-expire, no need to delete
```
**Warning:** This destroys the link to existing infrastructure!

**Option 3: Import Existing Resources**
If you have existing VPC/EKS that you want Terraform to manage:
```bash
terraform import module.vpc.aws_vpc.main vpc-xxxxx
terraform import module.eks.aws_eks_cluster.this cluster-name
```

**My Recommendation:**
- Use **Option 1** (different key)
- Or confirm old state is not needed and use **Option 2**

---

## 🔄 Complete Deployment Flow

### Flow 1: Infrastructure Provisioning (One-Time Setup)

```
┌─────────────────────────────────────────────────────────────────────────┐
│ STEP 1: Infrastructure Provisioning (Do this ONCE)                      │
└─────────────────────────────────────────────────────────────────────────┘

You (Local Machine):
  │
  ├─► terraform init                    # Initialize Terraform
  ├─► terraform plan -var-file=demo.tfvars   # Preview changes
  └─► terraform apply -var-file=demo.tfvars  # Create infrastructure
       │
       ├─► Creates VPC (10.0.0.0/16)
       ├─► Creates Subnets (public + private)
       ├─► Creates Internet Gateway
       ├─► Creates NAT Gateway
       ├─► Creates EKS Cluster
       ├─► Creates EKS Node Group (2x t3.medium)
       ├─► Creates IAM Roles
       └─► Creates Security Groups
       
       ⏱ Takes: 15-20 minutes
       
  ├─► terraform output                  # Get cluster info
  └─► aws eks update-kubeconfig --region eu-west-2 --name <cluster-name>
       │
       └─► Configure kubectl to connect to EKS
```

**State Storage:**
```
S3: s3://jatin-s3-shopnow-tfstate/terraform/terraform.tfstate
DynamoDB: jatin-shopnow-statelock (for locking)
```

---

### Flow 2: Application Build & Deployment

```
┌─────────────────────────────────────────────────────────────────────────┐
│ STEP 2: CI Pipeline (Build Docker Images)                               │
└─────────────────────────────────────────────────────────────────────────┘

Developer:
  │
  └─► git push to repository
       │
       │ (Webhook triggers Jenkins)
       ▼
       
Jenkins Server:
  │
  ├─► 1. Checkout Code
  │    git clone <repo-url>
  │
  ├─► 2. Build Docker Images
  │    docker build -t frontend:v1.0 ./frontend
  │    docker build -t backend:v1.0 ./backend
  │    docker build -t admin:v1.0 ./admin
  │
  ├─► 3. Tag Images for ECR
  │    docker tag frontend:v1.0 <ecr-url>/jatinggg-shopnow/frontend:v1.0
  │    docker tag backend:v1.0 <ecr-url>/jatinggg-shopnow/backend:v1.0
  │    docker tag admin:v1.0 <ecr-url>/jatinggg-shopnow/admin:v1.0
  │
  ├─► 4. Authenticate to ECR
  │    aws ecr get-login-password | docker login ...
  │
  └─► 5. Push to ECR
       docker push <ecr-url>/jatinggg-shopnow/frontend:v1.0
       docker push <ecr-url>/jatinggg-shopnow/backend:v1.0
       docker push <ecr-url>/jatinggg-shopnow/admin:v1.0
       
       ⏱ Takes: 5-10 minutes

┌─────────────────────────────────────────────────────────────────────────┐
│ STEP 3: CD Pipeline (Deploy to Kubernetes)                              │
└─────────────────────────────────────────────────────────────────────────┘

Jenkins Server:
  │
  ├─► 1. Configure kubectl (if not done)
  │    aws eks update-kubeconfig --region eu-west-2 --name <cluster-name>
  │
  ├─► 2. Create Namespace
  │    kubectl create namespace shopnow-demo --dry-run=client -o yaml | kubectl apply -f -
  │
  ├─► 3. Create ECR Secret (for private registry)
  │    kubectl create secret docker-registry ecr-secret \
  │      --docker-server=<ecr-url> \
  │      --docker-username=AWS \
  │      --docker-password=$(aws ecr get-login-password) \
  │      -n shopnow-demo
  │
  ├─► 4. Deploy MongoDB
  │    kubectl apply -f kubernetes/k8s-manifests/database/
  │
  ├─► 5. Deploy Backend
  │    kubectl apply -f kubernetes/k8s-manifests/backend/
  │
  ├─► 6. Deploy Frontend
  │    kubectl apply -f kubernetes/k8s-manifests/frontend/
  │
  ├─► 7. Deploy Admin
  │    kubectl apply -f kubernetes/k8s-manifests/admin/
  │
  └─► 8. Deploy Ingress
       kubectl apply -f kubernetes/k8s-manifests/ingress/
       
       ⏱ Takes: 3-5 minutes
```

---

## 🎯 What You Need to Do (YOUR SCENARIO)

Since you already have:
- ✅ Jenkins server running
- ✅ Docker images in ECR
- ✅ S3 bucket and DynamoDB table

**Your Simplified Flow:**

### Step 1: Update Terraform State Configuration (2 minutes)
```bash
# Edit eks-tf/provider.tf
# Change the state key to avoid conflicts:
backend "s3" {
  bucket         = "jatin-s3-shopnow-tfstate"
  key            = "capstone-deployment/terraform.tfstate"  # Changed from "terraform/terraform.tfstate"
  region         = "eu-west-2"
  dynamodb_table = "jatin-shopnow-statelock"
}
```

### Step 2: Verify Jenkins Has Required Tools (5 minutes)
```bash
# SSH into your Jenkins server
ssh ubuntu@<jenkins-ip>

# Verify tools exist:
docker --version        # Should show Docker version
aws --version          # Should show AWS CLI version
kubectl version --client  # Should show kubectl version
git --version          # Should show Git version

# If ANY are missing, run the Ansible playbook:
# (From your local machine)
ansible-playbook -i ansible/inventory/hosts ansible/playbooks/jenkins-setup.yml

# Otherwise, SKIP the Ansible step entirely!
```

### Step 3: Provision Infrastructure with Terraform (20 minutes)
```bash
cd eks-tf
terraform init
terraform plan -var-file=demo.tfvars
terraform apply -var-file=demo.tfvars  # Type 'yes'

# ☕ Wait 15-20 minutes

# Get cluster name
terraform output cluster_name

# Configure kubectl
aws eks update-kubeconfig --region eu-west-2 --name <cluster-name-from-output>
```

### Step 4: Install Kubernetes Prerequisites (5 minutes)
```bash
# Install metrics server
kubectl apply -f kubernetes/pre-req/metrics-server.yaml

# Install ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0-beta.0/deploy/static/provider/aws/deploy.yaml

# Install storage class
kubectl apply -f kubernetes/pre-req/storageclass-gp3.yaml
```

### Step 5: Deploy Application Using Existing ECR Images (10 minutes)
```bash
# Update K8s manifests to use your existing ECR images
# (They should already be configured in kubernetes/k8s-manifests/*/deployment.yaml)

# Create namespace
kubectl create namespace shopnow-demo

# Create ECR secret
kubectl create secret docker-registry ecr-secret \
  --docker-server=$(aws sts get-caller-identity --query Account --output text).dkr.ecr.eu-west-2.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region eu-west-2) \
  --namespace=shopnow-demo

# Deploy everything
kubectl apply -f kubernetes/k8s-manifests/namespace/
kubectl apply -f kubernetes/k8s-manifests/database/
kubectl apply -f kubernetes/k8s-manifests/backend/
kubectl apply -f kubernetes/k8s-manifests/frontend/
kubectl apply -f kubernetes/k8s-manifests/admin/
kubectl apply -f kubernetes/k8s-manifests/ingress/

# Wait for pods
kubectl get pods -n shopnow-demo --watch
```

### Step 6: Initialize MongoDB (3 minutes)
```bash
kubectl -n shopnow-demo exec -it mongo-0 -- mongosh
# In mongo shell:
use admin;
db.createUser({
  user: 'shopuser',
  pwd: 'ShopNowPass123',
  roles: [{ role: 'readWrite', db: 'shopnow' }, { role: 'dbAdmin', db: 'shopnow' }]
});
exit

# Restart backend
kubectl rollout restart deploy backend -n shopnow-demo
```

### Step 7: Access Application (1 minute)
```bash
# Get load balancer URL
kubectl get svc -n ingress-nginx

# Open in browser:
http://<load-balancer-dns>/jatin
http://<load-balancer-dns>/jatin-admin
```

**Total Time: ~45 minutes**

---

## 🤔 Jenkins Pipeline vs Manual Deployment

**Option A: Manual Deployment (What I described above)**
- You run Terraform from your local machine
- You run kubectl from your local machine
- Jenkins is just sitting there (used later for CI/CD)

**Option B: Jenkins-Driven Deployment**
- Jenkins runs Terraform (infrastructure provisioning)
- Jenkins runs kubectl (application deployment)
- Everything automated through pipelines

**For Capstone Assignment:**
- **Manual is fine** for infrastructure (one-time)
- **Jenkins CI/CD** for application builds and deployments (demonstrates automation)

---

## 📝 Summary: YOUR Scenario

1. **Jenkins Setup:** ✅ Already done - just verify tools are installed
2. **Ansible:** ⚠️ OPTIONAL - only if tools missing from Jenkins
3. **ECR Images:** ✅ Already done - reuse existing images
4. **S3/DynamoDB State:** ✅ Change state key in provider.tf OR delete old state
5. **Deployment:** Run Terraform → Deploy K8s manifests

**You're much further along than starting from scratch!** 🎉
