# Providers in Terraform

Providers are plugins that allow Terraform to interact with different cloud providers and services.

provider comminucation with cloud provider through API

terraform provider uses API of the cloud provider to create, update and delete the infrastructure.

## Different Providers in Terraform

1. AWS Provider : Provider which interacts with AWS cloud provider.
2. Azure Provider : Provider which interacts with Azure cloud provider.
3. Google Cloud Provider : Provider which interacts with Google Cloud provider.
4. Kubernetes Provider : Provider which interacts with Kubernetes.
5. Docker Provider : Provider which interacts with Docker.
6. Terraform Provider : Provider which interacts with Terraform.

## Syntax of Provider

```bash
terraform {
# required providers block used to define the providers which are used in the terraform configuration
required_providers {
    aws {
    source  = "hashicorp/aws"
    version = "~> 5.0" #
    }
}
}

# configuration of the provider
provider "aws" {
  region = "us-east-1"
}
```

In the above example, we are using the AWS provider and we are setting the region to us-east-1.

## AWS Provider of Terraform

Terraform connects with AWS cloud through API keys through safely authenticating the user.

## What is the Aws Provider ?

Terraform itself does not have the capability to depploy or create resources on the AWS like VPC, EC2, S3 etc.

Aws provider is a plugin which allows terraform to interact with AWS cloud or ability to communicate with AWS.

```
              Terraform
                 ↓
             AWS Provider
                 ↓
             AWS API
                 ↓
              AWS Resources
```

### AWS Provider in detail

AWS Provider is the software which is used to create, update and delete resources on the AWS.

### AWS Provider Authentication

AWS provider uses the following methods to authenticate the user:

1. Access Key and Secret Key
2. IAM Role
3. Environment Variables
4. AWS CLI
5. Shared Credentials File

### Syntax of AWS Provider

```hcl
provider "aws" {
  region = "ap-south-1" # This is the region where the resources will be created.
}
```

### Note:

1.  Terraaform needs AWS credentials to make API calls to AWS
2.  Access key and secret key are used to authenticate the user
3.  Does not store credentials in the code. Always use environment variables or shared credentials file.
4.  Do not hardcode credentials in the code.` dangerous because credentials can accidentally be committed to Git`.
5.  recommended use the aws cli to authenticate the user.

## Example : Environment Variables for AWS Provider authentication

```bash
export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_access_key
export AWS_REGION=your_region
```

```bash
#Then
source .env file
```

# How to CHECK AWS Provider Authentication

```bash
aws sts assume-role --role-arn arn:aws:iam::1234567890:role/MyRole --role-session-name MySession

or
aws sts get-caller-identity
```

# IAM Permission

Terraform does not automaticallly have the permission to create, update and delete resources on the AWS. We need to provide the IAM permission to the Terraform to create, update and delete resources on the AWS.

The AWS Identity and Access Management (IAM) is a web service that helps you securely control access to AWS resources. It allows you to manage user permissions, roles, and policies to ensure that only authorized users and services can access your resources.

Example terraform create an s3 bucket

```
             Terraform
                 ↓
            AWS Provider
                 ↓
           IAM credentials
                 ↓
             S3 API
                 ↓
           S3 Bucket
```

# Note

1. Terraform does not create the S3 bucket by itself
2. Terraform needs AWS credentials to make API calls to AWS
3. IAM role is used to authenticate the user
4. S3 API is used to create the S3 bucket
5. IAM role needs the S3 full access permission to create the S3 bucket

## Principle of least permission/privilege

"Principle of least privilege" is a security concept that states that a system component (like a user, application, or server) should only have the minimum level of permissions necessary to perform its job.

In simple terms ,Terraform only needs the permissions it actually needs to perform its job.

Why is it important in Terraform/DevOps?

1. Security:
2. Reducing blast radius:
3. Better audit trail:
4. Separation of duties:
5. Prevents accidental changes:

## IAM Role

```hcl
resource "aws_iam_role" "terraform" {
  name = "terraform"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform" {
  role       = aws_iam_role.terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
```

## Provider vs Resource

### Provider

Provider is a plugin that allows Terraform to interact with different cloud providers and services. It is a bridge between Terraform and the cloud provider.

Connect Terraform to AWS, Azure, GCP, Kubernetes, Docker, etc.

### Resource

Resource is a block which is used to define the infrastructure. It is a representation of the infrastructure that Terraform creates.

Create an S3 bucket in AWS.

| Feature                 | Provider   | Resource |
| ----------------------- | ---------- | -------- |
| Definition              | Plugin     | Block    |
| Purpose                 | Interact   | Define   |
| Example                 | AWS, Azure | EC2, S3  |
| Communication           | API        | -        |
| State Management        | -          | Yes      |
| Module System           | -          | Yes      |
| Plan and Apply Workflow | -          | Yes      |

## Important Security Rules

❌ Don't hardcode AWS secrets
❌ Don't commit credentials to Git
❌ Don't make state files public
❌ Don't give unnecessary IAM permissions

✅ Use AWS CLI/profile or role-based authentication
✅ Use least-privilege IAM
✅ Protect Terraform state
✅ Review terraform plan before apply

# Aws S3 With Terraform

We will create a S3 bucket in AWS using Terraform. This espically useful for static website hosting, storing backups, and data storage.

## What is S3 Bucket?

Amazon S3 (Simple Storage Service) is an object-storage service.

It can store any amount of data and retrieve it from anywhere on the web. like image, video, documents, HTML/CSS/JS files, backups, Application assets and many more.

| Feature           | Description                          |
| ----------------- | ------------------------------------ |
| **What it is**    | Object storage service               |
| **Used For**      | Static websites, backups, data       |
| **Stores**        | Objects (files) in buckets           |
| **Key Feature**   | Scalable, durable, secure            |
| **Access Method** | REST API, SDKs, CLI                  |
| **Location**      | Global service with regional buckets |

## Basic structure:

```
S3 Bucket
│
├── index.html
├── style.css
├── app.js
└── assets/
    ├── logo.png
    └── image.jpg

```

## Syntax of Aws S3 With Terraform

```bash
# Terraform configuration to create an S3 bucket in AWS

# 1. Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# 2. Define the S3 Bucket Resource -> must be globally unique
resource "aws_s3_bucket" "website" {
  bucket = "my-first-website-bucket-new-12345"
}
#  aws_s3_bucket -> provider_resourceType / terraform resource Type
#  website -> resource name used to reference this resource in other parts of the Terraform configuration


# 3. (Optional) Enable Versioning
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 4. (Optional) Set Public Access Block
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 5. (Optional) Enable Static Website Hosting
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# 6. (Optional) Define Bucket Policy for Public Access
resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.example.bucket}/*"
        ]
      }
    ]
  })
}

# 7. Output the Bucket URL
output "bucket_url" {
  description = "The website URL of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.example.website_endpoint
}
```

## Upload a project file to S3 Bucket

```bash
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "./index.html"
  content_type = "text/html"
  etag         = filemd5("./index.html")  # To validate file hash and detect changes
}
```

## Upload a project file to S3 Bucket (Example: All assert folder files)

```bash
resource "aws_s3_object" "assert_files" {
  for_each     = fileset("${path.module}/assert", "*") # Iterates over all files in the assert directory
  bucket       = aws_s3_bucket.website.id
  key          = "assert/${each.value}"            # Creates a folder named 'assert' in the S3 bucket
  source       = "${path.module}/assert/${each.value}"
  etag         = filemd5("${path.module}/assert/${each.value}")
  content_type = "image/png"                        # Sets the content type for the uploaded files
}
```

### `fileset` function

The `fileset(path, pattern)` function generates a map of files that match the specified pattern within a given directory path.finds files inside a directory.

- **path**: The directory path to search for files.
- **pattern**: The pattern to match files against (e.g., "_" for all files, "_.html" for HTML files, "\*.jpg" for JPEG files).

**Example**:
`fileset("${path.module}/assert", "*")` will return a map of all files in the `assert` directory.

### `path.module`

The `path.module` function returns the absolute path of the directory containing the current Terraform configuration file.

`path.module` is a Terraform expression that returns the filesystem path of the current module. It is commonly used to reference local files reliably.

**Example**:
If our `main.tf` file is located at `E:/Terraforme/project/main.tf`, then `path.module` will return `E:/Terraforme/project`.

`source = "${path.module}/assets/index.html"` -> `source = "E:/Terraforme/project/assets/index.html"`
mean `Find index.html inside the assets directory of the current Terraform module.`

### filemd5 function

The `filemd5(path)` function returns the MD5 hash of the file at the specified path.

**Example**:
`filemd5("./index.html")` will return the MD5 hash of the `index.html` file.

## Important Difference:

- **Source** : Path to the file in the local filesystem
- **Content Source** : Content of the file
- **Key** : The name of the file in the S3 bucket
- **content_type** : Type of the file
- **etag** : MD5 hash of the file

## How Terraform Creates an S3 Bucket

1. **Terraform Initialization**: Runs `terraform init` to download the AWS provider plugin.
2. **Terraform Plan**: Runs `terraform plan` to analyze the configuration and determine what needs to be created, updated, or deleted.
3. **Terraform Apply**: Runs `terraform apply` to execute the changes.
   - Terraform communicates with the AWS API using your credentials.
   - It creates the S3 bucket with the specified configuration.
   - It enables versioning (optional).
   - It configures public access settings (optional).
   - It sets up static website hosting (optional).
   - It applies the bucket policy (optional).
4. **State Update**: Terraform updates the state file (`terraform.tfstate`) to record the created resources.
5. **Output**: Displays the bucket URL (if defined in outputs).

## Key Parameters Explained

| Parameter                  | Description                                                        |
| -------------------------- | ------------------------------------------------------------------ |
| `provider "aws"`           | Configures the AWS provider with the specified region.             |
| `bucket`                   | Unique name for the S3 bucket. Must be globally unique.            |
| `versioning_configuration` | Enables or disables versioning to keep multiple object versions.   |
| `block_public_acls`        | Prevents public ACLs from being applied to the bucket.             |
| `block_public_policy`      | Prevents public bucket policies from being applied.                |
| `ignore_public_acls`       | Ignores any existing public ACLs on the bucket.                    |
| `restrict_public_buckets`  | Restricts public access to only the bucket owner.                  |
| `index_document`           | Specifies the default file to serve when a directory is requested. |
| `error_document`           | Specifies the file to serve when an error occurs.                  |
| `bucket_policy`            | Defines access permissions for the bucket using JSON policy.       |
| `output`                   | Exports values from the configuration for use elsewhere.           |

## Important Notes

1. **Unique Bucket Name**: S3 bucket names must be globally unique across all AWS accounts.
2. **Public Access**: By default, S3 buckets are private. You must explicitly enable public access if needed.
3. **Versioning**: Versioning should be enabled for production buckets to prevent accidental data loss.
4. **Security**: Always use the principle of least privilege and configure public access block.
5. **Outputs**: Use outputs to easily access bucket information after creation.

## Important production Notes:

For real static website ->` s3 bucket + upload files`

`s3 -> Bucket configuration -> public/private access->cloudfront -> HTTPS -> Custiom domain`

Remember pattern

`path.module -> asset folder -> fileset() -> for_each ->   aws_s3_object -> s3 Bucket`
