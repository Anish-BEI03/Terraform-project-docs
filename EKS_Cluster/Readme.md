# Amazon EKS Cluster Infrastructure with Terraform

This project automates the provisioning of a production-ready **Amazon Elastic Kubernetes Service (EKS)** cluster along with a dedicated **VPC network topology** on AWS using Terraform.

---

## Architecture Overview

```
                                      AWS Region: us-east-1
+---------------------------------------------------------------------------------------------------+
|  VPC: 10.0.0.0/16 (eks-cluster-demo-vpc)                                                          |
|                                                                                                   |
|   +------------------------------------+         +------------------------------------+           |
|   | Availability Zone: us-east-1a      |         | Availability Zone: us-east-1b      |           |
|   |                                    |         |                                    |           |
|   |  [ Public Subnet: 10.0.1.0/24 ]    |         |  [ Public Subnet: 10.0.2.0/24 ]    |           |
|   |  - Internet Gateway (IGW)          |         |  - Routes to IGW                   |           |
|   |  - NAT Gateway (Elastic IP)        |         |  - Tag: kubernetes.io/role/elb     |           |
|   |  - Tag: kubernetes.io/role/elb     |         |                                    |           |
|   |                                    |         |                                    |           |
|   |  [ Private Subnet: 10.0.101.0/24 ] |         |  [ Private Subnet: 10.0.102.0/24 ] |           |
|   |  - Routes outbound via NAT Gateway |         |  - Routes outbound via NAT Gateway |           |
|   |  - EKS Managed Node Group (Nodes)  |         |  - EKS Managed Node Group (Nodes)  |           |
|   |  - Tag: .../role/internal-elb      |         |  - Tag: .../role/internal-elb      |           |
|   |                                    |         |                                    |           |
|   |  [ Intra Subnet: 10.0.5.0/24 ]     |         |  [ Intra Subnet: 10.0.6.0/24 ]     |           |
|   |  - Isolated internal subnet        |         |  - Isolated internal subnet        |           |
|   +------------------------------------+         +------------------------------------+           |
|                                                                                                   |
|  [ EKS Control Plane: eks-cluster-demo (v1.31) ]                                                  |
|  - Endpoint: Public & Private Access Enabled                                                      |
|  - Authentication: Cluster Creator Admin Access Entries                                           |
|  - Addons: vpc-cni, kube-proxy, coredns                                                           |
|                                                                                                   |
|  [ EKS Managed Node Group: anish-cluster-node ]                                                   |
|  - Instance Type: t3.medium (Capacity: SPOT)                                                      |
|  - Scaling: Min: 1, Max: 2, Desired: 1                                                            |
|  - OS: Amazon Linux 2023 (AL2023_x86_64_STANDARD)                                                 |
+---------------------------------------------------------------------------------------------------+
```

---

## File Structure

```text
EKS_Cluster/
├── terraform.tf     # Terraform settings and required providers (AWS, TLS)
├── provider.tf      # AWS provider configuration
├── variables.tf     # Local variables (CIDRs, subnets, AZs, cluster name, tags)
├── vpc.tf           # AWS VPC module (subnets, NAT Gateway, route tables, tags)
├── eks.tf           # AWS EKS module (control plane, addons, node group)
└── Readme.md        # Project documentation
```

---

## Infrastructure Components

### 1. Networking (`vpc.tf` & `variables.tf`)

- **Module**: `terraform-aws-modules/vpc/aws` (`~> 6.0`)
- **VPC CIDR**: `10.0.0.0/16`
- **Availability Zones**: `us-east-1a`, `us-east-1b`
- **Subnets**:
  - **Public Subnets**: `10.0.1.0/24`, `10.0.2.0/24` (tagged with `"kubernetes.io/role/elb" = 1` for public ALBs).
  - **Private Subnets**: `10.0.101.0/24`, `10.0.102.0/24` (tagged with `"kubernetes.io/role/internal-elb" = 1` for internal ALBs).
  - **Intra Subnets**: `10.0.5.0/24`, `10.0.6.0/24` (isolated non-routable subnets).
- **Outbound Connectivity**: Single NAT Gateway enabled in the public subnet to minimize infrastructure cost while allowing private node access to container registries and the internet.

### 2. Kubernetes Cluster (`eks.tf`)

- **Module**: `terraform-aws-modules/eks/aws` (`~> 21.0`)
- **Cluster Name**: `eks-cluster-demo`
- **Kubernetes Version**: `1.31`
- **Cluster Access**:
  - `endpoint_public_access = true`
  - `enable_cluster_creator_admin_permissions = true` (uses EKS Access Entries so the deploying IAM identity has cluster-admin permissions).
- **Subnet Placement**: Placed in `module.vpc.private_subnets` to ensure secure connectivity via the NAT Gateway.

### 3. Core Addons

- **`vpc-cni`**: AWS VPC Container Network Interface for pod networking.
- **`kube-proxy`**: Kubernetes network proxy running on each node.
- **`coredns`**: Cluster DNS resolution.

### 4. Managed Node Group

- **Name**: `anish-cluster-node`
- **Instance Types**: `t3.medium`
- **Capacity Type**: `SPOT` (provides up to 90% cost savings for dev environments).
- **Scaling Limits**:
  - Desired: `1`
  - Minimum: `1`
  - Maximum: `2`
- **AMI Type**: Amazon Linux 2023 (`AL2023_x86_64_STANDARD`) with IMDSv2 enforced.

---

## Prerequisites

1. **AWS CLI** installed and configured:
   ```bash
   aws configure
   ```
2. **Terraform** (`>= 1.5.7`) installed.
3. **kubectl** installed for managing Kubernetes resources.

---

## Deployment Steps

### 1. Initialize Terraform

Downloads all required providers (`aws`, `tls`) and modules (`vpc`, `eks`):

```bash
terraform init
```

### 2. Validate Configuration

Ensure all HCL syntax and arguments are valid:

```bash
terraform validate
```

### 3. Review Plan

Inspect the resources Terraform will create:

```bash
terraform plan
```

### 4. Apply Configuration

Deploy the infrastructure to AWS (provisioning typically takes 10–12 minutes):

```bash
terraform apply -auto-approve
```

---

## Connecting to the Cluster

Once `terraform apply` finishes:

1. **Update your local `kubeconfig`**:

   ```bash
   aws eks update-kubeconfig --region us-east-1 --name eks-cluster-demo
   ```

2. **Verify cluster nodes**:

   ```bash
   kubectl get nodes
   ```

3. **Verify core pods and addons**:
   ```bash
   kubectl get pods -A
   ```

---

## Troubleshooting & Key Learnings

1. **VPC Quota Limit (`VpcLimitExceeded`)**:
   - AWS accounts have a default limit of **5 VPCs per region**.
   - If reached, delete an unused VPC or deploy into an existing VPC before creating a new one.

2. **KMS Permissions (`AccessDeniedException: kms:TagResource`)**:
   - If the IAM user lacks permissions to manage customer-managed KMS keys, configure `create_kms_key = false` and `encryption_config = null` in `eks.tf` to utilize AWS default managed encryption.

3. **Subnet Types in `terraform-aws-modules/vpc/aws`**:
   - `public_subnet_tags` and `private_subnet_tags` must be a `map(string)` (e.g. `{"kubernetes.io/role/elb" = 1}`).
   - Lists of subnet names must use `public_subnet_names` and `private_subnet_names`.

4. **Control Plane Subnet Placement**:
   - Do **not** place the EKS control plane ENIs in isolated `intra_subnets` unless private VPC Endpoints are fully provisioned. The control plane must be in `private_subnets` with outbound route to the NAT Gateway to bootstrap successfully.

---

## Clean Up / Destruction

To tear down all resources and avoid ongoing AWS charges:

```bash
terraform destroy -auto-approve
```
