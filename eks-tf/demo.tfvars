tags = {
  Environment = "demo"
  Owner       = "Jatin"
}
region              = "eu-west-2"
vpc_id              = "vpc-0376ebe6043cd8004"
eks_subnet_ids      = ["subnet-01d94082ca6384cae", "subnet-067a0303e6a0bb68f"]
eks_cluster_name    = "jatin-demo-01"
vpc_cni_role_name   = "AmazonEKSVPCCNIRole-jatin-demo-02"
eks_cluster_version = "1.31"
aws_lbc_role_name   = "aws-lbc-jatin-demo-02"