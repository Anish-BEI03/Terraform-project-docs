module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # cluster configurations info (control plane)
  name               = local.name
  kubernetes_version = "1.31"

  # public endpoints
  endpoint_public_access = true

  # Disable custom KMS key creation and encryption config
  create_kms_key           = false
  encryption_config        = null
  attach_encryption_policy = false

  # Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  # vpc configurations
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # addon configurations (cluster level)
  addons = {
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
  }

  # nodegroup configuration
  eks_managed_node_groups = {
    anish-cluster-node = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

      attach_cluster_primary_security_group = true
    }
  }

  # add tags
  tags = {
    Name        = local.name
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}