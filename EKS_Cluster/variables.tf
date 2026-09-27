locals {
  region     = "us-east-1"
  name       = "eks-cluster-demo"
  vpc_cidr   = "10.0.0.0/16"
  azs        = ["us-east-1a", "us-east-1b"]
  pub_sub    = ["10.0.1.0/24", "10.0.2.0/24"]
  intra_sub  = ["10.0.5.0/24", "10.0.6.0/24"]
  priv_sub   = ["10.0.101.0/24", "10.0.102.0/24"]
  pub_tags   = ["public-subnet-1", "public-subnet-2"]
  priv_tags  = ["private-subnet-1", "private-subnet-2"]
  intra_tags = ["intra-subnet-1", "intra-subnet-2"]
  env        = "dev"
}
