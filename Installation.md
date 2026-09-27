# Installing and Configuring Terraform

Terraform is a single compiled binary written in Go language. It does not require any background daemon or agent process running

Terraform does not require any additional runtime or framework.

1. Installation

A. Windows

    1. Binary Download
    2. Environment Variables
    3. Verification

    ```
    # Using Chocolatey:
     choco install terraform

    # Using Winget:
     winget install HashiCorp.Terraform
    ```

B. Linux(Ubuntu/Debian)

    ```bash
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update && sudo apt-get install -y terraform
    ```
    ```bash
    # Verify installation
    terraform -version
    ```

C. MacOS(Homebrew)

    ```bash
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ```

    ```bash
    # Verify installation
    terraform -version
    ```

2. Setting Up AWS Authentication

Terraform uses AWS credentials to authenticate with AWS services. You can set up AWS credentials in the following ways:

    1. AWS CLI Configuration (Recommended)
        ```bash
        aws configure
        # Enter AWS Access Key ID: AKIAXXXXXXXXXXXXXXXX
        # Enter AWS Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
        # Default region name: us-east-1
        # Default output format: json
        ```
    2. Environment Variables(Optional)

        ```bash
        export AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX
        export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
        export AWS_DEFAULT_REGION=us-east-1
        ```
    3. IAM Roles for EC2 Instances

        - Create an IAM Role with the desired permissions
        - Attach the IAM Role to an EC2 Instance

    4. ECS Credential Provider (Recommended)

    5. Verify AWS Credentials

    ```bash
    aws sts get-caller-identity
    ```

# Verifying your Terraform installation

A. Verify Terraform installation

    ```bash
    terraform -version
    ```

B. Verify AWS CLI installation and configuration

    ```bash
    aws sts get-caller-identity
    ```

# HashiCorp Configuration Language(HCL) Core Syntax

## What is HashiCorp Configuration Language(HCL)?

HCL is a declarative configuration language that is used to define infrastructure resources.

HCL is designed to strike a balance between human readability and machine parsability. It is a superset of JSON, meaning that any valid JSON is also valid HCL.

## Syntax

### Anatomy of A HCL Block

Every declarative configuration is made up of blocks.

```H
<block_type> "<Resource/Type Label> <Local/Logical Name>" {
    <Identifier> = <Expression>
}
```

Example:

```H
resource "aws_vpc" "dec5vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "dec5vpc"
        Environment = "dev"
        Project = "dec5"
        Owner = "Venu"
        ManagedBy = "Terraform"
    }
}
```

A block consists of the following components:

1. Type : The type of the block (e.g., resource, variable, data, module, output, provider)
2. Name : The name of the block (e.g., aws_s3_bucket)
3. Body : The body of the block (e.g., bucket = var.name)

```H
# Comments
variable "name" {
  description = "The name of the resource"
  type        = string
}

resource "aws_s3_bucket" "example" {
  bucket = var.name
}
```

```h
variable "name" {
  description = "The name of the resource"
  type        = string
}

resource "aws_s3_bucket" "example" {
  bucket = var.name
}
```

HCL is a domain-specific language (DSL) that is optimized for configuration management and provisioning.

Key Features of HCL:

    1. Simple and Readable Syntax : HCL is designed to be simple and readable, making it easy to write and understand configuration files.
    2. Declarative Configuration : HCL is a declarative language, which means that you define the desired state of the infrastructure and Terraform takes care of the rest.
    3. Type System : HCL has a type system that allows you to define the type of each variable, making it easier to catch errors early on.
    4. Module System : HCL allows you to organize your infrastructure code into reusable modules.
    5. Provider Ecosystem : HCL has a rich ecosystem of providers that allow you to manage infrastructure across different cloud providers and services.

HCL is a powerful and flexible language that can be used to define infrastructure resources. It is a declarative language that is simple and readable, making it easy to write and understand configuration files.
