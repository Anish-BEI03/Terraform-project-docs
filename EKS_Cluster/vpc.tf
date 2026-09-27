module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.priv_sub
  public_subnets  = local.pub_sub
  intra_subnets   = local.intra_sub

  # Individual subnet names
  public_subnet_names  = local.pub_tags
  private_subnet_names = local.priv_tags
  intra_subnet_names   = local.intra_tags

  # Subnet tags must be a map(string)
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  intra_subnet_tags = {
    "kubernetes.io/role/cni" = 1
  }

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}
