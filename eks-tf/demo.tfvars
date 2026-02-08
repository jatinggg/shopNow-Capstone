tags = {
  Environment = "demo"
  Owner       = "Jatin"
}

region                = "eu-west-2"
eks_cluster_name      = "jatin-demo-01"
eks_cluster_version   = "1.31"
vpc_cni_role_name     = "AmazonEKSVPCCNIRole-jatin-demo-02"
aws_lbc_role_name     = "aws-lbc-jatin-demo-02"
environment           = "demo"

# VPC Configuration - Creates new VPC
vpc_cidr              = "10.0.0.0/16"
public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  = ["10.0.10.0/24", "10.0.11.0/24"]
enable_nat_gateway    = true
