# VPC Module - Creates new VPC with subnets
module "vpc" {
  source = "./modules/vpc"

  cluster_name         = var.eks_cluster_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  tags                 = var.tags
}

# EKS Module - Creates EKS cluster using VPC from above
module "eks" {
  source = "./modules/eks"

  cluster_name      = var.eks_cluster_name
  cluster_version   = var.eks_cluster_version
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
  vpc_cni_role_name = var.vpc_cni_role_name
  aws_lbc_role_name = var.aws_lbc_role_name
  tags              = var.tags
  region            = var.region

  depends_on = [module.vpc]
}
