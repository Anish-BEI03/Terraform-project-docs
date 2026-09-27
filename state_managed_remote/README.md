# Terraform Remote State Management with AWS S3 & DynamoDB

This project demonstrates how to store and manage Terraform state files remotely in an **Amazon S3 bucket** with **DynamoDB state locking**, while provisioning a secure Nginx web server on an **Amazon EC2** instance.

---

## 📌 Architecture Overview

```
                        ┌────────────────────────────────────────┐
                        │          Terraform CLI (Local)         │
                        └───────────────────┬────────────────────┘
                                            │
                       ┌────────────────────┴────────────────────┐
                       ▼                                         ▼
            State File & Locking                       Infrastructure
         ┌─────────────────────────┐               ┌────────────────────────┐
         │ AWS S3 Remote Backend   │               │ AWS EC2 (t3.micro)     │
         │ - Bucket Versioning     │               │ - Ubuntu Linux         │
         │ - AES256 Encryption     │               │ - Nginx Web Server     │
         │                         │               └───────────┬────────────┘
         │ AWS DynamoDB Table      │                           │
         │ - LockID attribute (S)  │               ┌───────────┴────────────┐
         │ - State lock protection │               │ AWS Security Group     │
         └─────────────────────────┘               │ - Port 80 (HTTP)       │
                                                   └────────────────────────┘
```

---

## 📁 File Structure

| File                         | Purpose                                                                            |
| :--------------------------- | :--------------------------------------------------------------------------------- |
| [terraform.tf](terraform.tf) | Configures required providers (`aws`, `random`) and the remote `backend "s3"`.     |
| [provider.tf](provider.tf)   | Defines the AWS provider region (`us-east-1`).                                     |
| [s3.tf](s3.tf)               | Provisions the S3 bucket with random hex suffix and enables bucket versioning.     |
| [dynamodb.tf](dynamodb.tf)   | Provisions the DynamoDB table with `LockID` partition key for state locking.       |
| [main.tf](main.tf)           | Provisions the EC2 instance (`t3.micro`), security group, and `random_pet` naming. |
| [outputs.tf](outputs.tf)     | Outputs the instance domain name and web application URL.                          |
| [script.sh](script.sh)       | User-data bootstrap script that installs, starts, and verifies Nginx.              |

---

## ⚙️ Prerequisites

1. **AWS CLI** configured (`aws configure`) with valid credentials.
2. **Terraform** (v1.5+) installed.
3. Access permissions for EC2, S3, and VPC in your target region (`us-east-1`).

---

## 🚀 Step-by-Step Deployment Workflow

Remote state management has a **chicken-and-egg** challenge: _Terraform cannot store its state in an S3 bucket that hasn't been created yet._ Follow this 2-stage workflow:

### Stage 1: Provision the Backend Storage (Local State)

1. Keep the `backend "s3"` block in [terraform.tf](terraform.tf) **commented out**.
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Apply the S3 bucket resource to create your remote storage:
   ```bash
   terraform apply
   ```
4. Note the generated bucket name from AWS S3 (e.g. `terraform-state-bucket-7a7cc75793cd04a7`).

---

### Stage 2: Configure Backend & Migrate State to S3

1. In [terraform.tf](terraform.tf), uncomment the `backend "s3"` block and supply the exact literal bucket name:

   ```hcl
   terraform {
     backend "s3" {
       bucket  = "terraform-state-bucket-7a7cc75793cd04a7"
       key     = "terraform.tfstate"
       region  = "us-east-1"
       encrypt = true
     }
   }
   ```

   _(Optional for locking)_: Add `dynamodb_table = "terraform-state-table-1"` if DynamoDB is used.

2. Run `terraform init -migrate-state` to copy your local state file into S3:

   ```bash
   terraform init -migrate-state
   ```

   Type `yes` when prompted to confirm the state migration.

3. Verify that the state file is now safely stored in the S3 bucket:
   ```bash
   aws s3 ls s3://terraform-state-bucket-7a7cc75793cd04a7/
   ```

---

### Stage 3: Provision / Update the Infrastructure

1. Plan and apply your changes (e.g. EC2 instance and Nginx web server):
   ```bash
   terraform plan
   terraform apply
   ```
2. Once the run completes, visit the application URL output in your browser:
   ```
   Outputs:
   application-url = "http://ec2-54-242-87-11.compute-1.amazonaws.com"
   domain-name     = "ec2-54-242-87-11.compute-1.amazonaws.com"
   ```

---

## 🧹 Teardown & Cleanup

To remove the created infrastructure and avoid ongoing AWS charges:

```bash
terraform destroy
```

> **Note**: If versioning is enabled on the S3 state bucket, all object versions must be emptied before the bucket can be deleted.

---

## 💡 Key Lessons & Best Practices

1. **No Variables in Backend Blocks**:
   Terraform evaluates the backend configuration _before_ loading variables or interpolations. Values like `bucket` and `region` in the `backend` block must be plain string literals or passed via `-backend-config`.

2. **Bucket Versioning**:
   Always enable versioning on state buckets (`aws_s3_bucket_versioning`). This protects against accidental state corruption or overwrites by allowing you to roll back to any past state version.

3. **Encryption at Rest**:
   Enable `encrypt = true` in the backend block so AWS KMS / AES256 encrypts your state file, protecting sensitive variables and resource attributes.

4. **State Locking**:
   State locking prevents simultaneous `terraform apply` executions from corrupting the state file when multiple team members or CI/CD pipelines run at the same time.
