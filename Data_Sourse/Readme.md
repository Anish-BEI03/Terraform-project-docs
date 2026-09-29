# Data Sources In Terraform

A data source in Terraform is a way to fetch information from an external source and use it in our Terraform configuration. Example : AWS S3 bucket, AWS Security Group, AWS EC2 instance, etc.
It is used to fetch information about existing resources. `We can't create, update, or delete resources using data sources`. We can only fetch information about existing resources.

It is `read-only data for existing resources`.

## In simple word

data source is used to read existing information from a provider or external system without creating or modifying anything or managing that object.

**Useful for obtainig dynamic data** that we need for our terraform configuration.

**Resource** -> Create/update/delete or manage the object.
**Data Source** -> Find/Read only or fetch the object information of existing resource.

## Syntax of Data Source

```bash
data "<provider>_<data-source-type>" "<data-source-name>" {
    #Arguments used to find/read the object of existing resource
}
```

## Arguments

Arguments are optional. We can provide arguments to the data source to specify the information we want to fetch.
Commonly used arguments are:
id
name
tags
filters

## Example of Data Source

```bash
data "aws_ami" "example" {
    most_recent = true
    owners      = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*"]
    }
}
```

## Data sources attributes

Data sources have attributes that can be used in other resources or outputs.
**Structure of attributes**

```bash
data.<TYPE>.<NAME>.<ATTRIBUTE>
```

#### Example of attributes reference

`data.aws_ami.example.id`
`data.aws_s3_bucket.example.id`

## Common data sources in Terraform /Data source types

aws_ami
aws_s3_bucket
aws_security_group
aws_vpc
aws_subnet
aws_instance
aws_route53_zone
aws_iam_role
aws_iam_instance_profile

## Output of Data Source

Data sources can have attributes that can be used in other resources or outputs.
Example :
`data.aws_ami.example.id`

## Why do we need data sources?

1. We need to use IDs of existing resources in other resources. Example: We need to use the ID of an existing VPC in a subnet resource.
2. We need to fetch information about existing resources and use it in our Terraform configuration.
3. To obtain dynamic data that we need for our terraform configuration.
4. Data sources are also used to fetch information about existing resources and use it in other resources. Example: We can use the ID of an existing AMI in an EC2 instance resource.

## Example

suppose an existing VPC with cidr

```
 AWS
└── VPC
    ├── ID: vpc-012345
    ├── CIDR: 10.0.0.0/16
    └── Name: production-vpc
```

```
Data Source (fetch information)
    ↓
    | vpc-012345
    | 10.0.0.0/16
    ↓
Resource (use information)
    ↓
AWS Subnet
    ├── ID: subnet-abcdef
    ├── CIDR: 10.0.1.0/24
    └── VPC ID: [reference to vpc-012345]
```

Terraform can look up the VPC dynamically using data source

## Data source vs Resource

| Feature       | Data Source                 | Resource                            |
| ------------- | --------------------------- | ----------------------------------- |
| **Purpose**   | Read existing data          | Create/Manage resources             |
| **Action**    | Read-only                   | CRUD operations                     |
| **Lifecycle** | No impact on infrastructure | Full management                     |
| **Example**   | `data "aws_ami" "example"`  | `resource "aws_instance" "example"` |

## Key Points

- Data sources are used to fetch information about existing resources.
- Data sources are read-only.
- Data sources are used to obtain dynamic data that we need for our terraform configuration.
- Data sources can have attributes that can be used in other resources or outputs.
- Data sources are not used to create, update, or delete resources.

## How to use data sources

Data sources are used to fetch information about existing resources.
Example : We can use the ID of an existing AMI in an EC2 instance resource.

1. data source should have attributes (name, id, tags, filters) or arguments (id, name, tags, filters)
2. data source should have reference name
3. data source should have output attributes

## Example

```bash
data "aws_ami" "example" {
    most_recent = true
    owners      = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*"]
    }
}

resource "aws_instance" "example" {
    ami           = data.aws_ami.example.id
    instance_type = "t2.micro"
    tags = {
        Name = "example"
    }
}
```

**There are two names here**

```bash
aws_ami
   │
   └── Data source type

example
   │
   └── Local name inside Terraform

```

# How Data Source Work Internally

1. Terraform reads the data source configuration
2. Terraform identify the data source type and the provider
3. Terraform use the data source to fetch information from the provider
4. Terraform store the information in the state file
5. Terraform use the information to create or update the resources

For Example:

```bash
data "aws_vpc" "main" {
  tags = {
    Name = "production"
  }
}
```

**Terraform execution**

```bash
terraform plan
       │
       ▼
Terraform configuration
       │
       ▼
    AWS Provider
       │
       ▼
    AWS API
       │
       ▼
Find VPC with Name=production
       │
       ▼
Return VPC information
       │
       ▼
    Terraform
       │
       ▼
data.aws_vpc.main.id
```
