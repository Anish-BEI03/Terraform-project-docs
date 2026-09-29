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

### Real time scenarion: Existing VPC + New EC2

Suppose we have an existing VPC with CIDR 10.0.0.0/16 and we want to create a new EC2 instance in that VPC.

```
For Architecture Diagram
                                          Existing AWS infrastructure
                                                 │
                                                 │ data sources
                                                 ▼
                                              Terraform
                                                 │
                                                 │ resource
                                                 ▼
                                           New EC2 instance

For existing VPC resources:
AWS
│
├── VPC
│   └── production
│
├── Subnet
│   └── production-public
│
└── Security Group
   └── web-server
```

```bash
# find existing VPC
data "aws_vpc" "main" {
  tags = {
    Name = "production"
  }
}
# find existing Subnet
data "aws_subnet" "main" {
  tags = {
    Name = "production-public"
  }
}
# find existing Security Group
data "aws_security_group" "main" {
  tags = {
    Name = "web-server"
  }
}

# now create new EC2 in existing VPC
resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    subnet_id     = data.aws_vpc.main.subnet_id
    vpc_security_group_ids = [data.aws_security_group.main.id]
    tags = {
        Name = "example"
    }
}
```

### **Note:**

Data Source does not mean import.

**Data Source** :- **use to read existing object information from cloud infra or terraform state file (no impact on infra) using arguments than retun attributes.**

It does not mean Terraform manages the VPC. It just fetches the information about the existing VPC and use that information to create or update the resources.

**Import** :- **use to import existing object information from cloud information and manage it using resource for terraform state file.**
This infrastructure already exists, but I want Terraform to start managing it.

**_syntax_**

```bash
# Import ->Bring existing infrastructure under Terraform management
terraform import <RESOURCE_ADDRESS> <RESOURCE_ID>

<RESOURCE_ADDRESS> -> resource type and name
<RESOURCE_ID> -> resource id
```

## Example

```
import {
  to = aws_vpc.main
  id = "vpc-0123456789abcdef0"
}
```

# Data Source Attribute : we provide to find the object in cloud infra and we get the data from the object (read) from cloud infra

```
                Arguments
                    ↓
            Search/filter
                    ↓
                Provider
                    ↓

                Attributes
                    ↓
            Returned information
```

For Example :

1. **`id` argument** is used to find the object in cloud

```bash
data "aws_vpc" "main" {
  id = "vpc-123456"
}
```

2. **`tag` argument** is used to find the object in cloud

```bash
data "aws_vpc" "main" {
  tags = {
    Name = "production"
  }
}
```

3. **`filter` argument** is used to find the object in cloud or powerful feature to use multiple conditions to find the object in cloud

```bash
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["production"]
  }
}
```

For Example:

```bash
# Example: Search by Availability Zone and Tag

data "aws_subnet" "main" {
  availability_zone = "us-east-1a"
  filter {
    name   = "tag:Name"
    values = ["production-subnet"]
  }
}

# Example: search recent ami
data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}
```

### Attribute of data source: Information returned by the data source

For Example:

```bash
data.aws_subnet.example.id
data.aws_subnet.example.cidr_block
data.aws_subnet.example.vpc_id
data.aws_subnet.example.availability_zone
data.aws_vpc.example.enable_dns_support etc
```

## Data source with Variables

For Example:

```bash
variable "vpc_name" {
  type        = string
  description = "Name of the VPC to search for"
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = data.aws_vpc.main.id
  tags = {
    Name = "example"
  }
}
```

**Now we can run the terraform**

```bash
terraform plan -var "vpc_name=production"
```

## Data Source vs local values

```
local
  ↓
Terraform calculation/value

data source
  ↓
External system/API lookup
```

Example:

```bash
// local value
locals {
  ami_id = "ami-0c55b159cbfafe1f0" //Hardcoded value
}

// Data source
data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}
```

**locals value**

```bash
locals {
  vpc_id = "vpc-123456"
}
```

**data source**

data "aws_vpc" "main" {
id = "vpc-123456"
}

## Data source Dependencies

Data sources can depend on resources and other data sources. But in general Data source depend on Provider.

```bash
# data source depend on provider

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

# data source depend on resource

data "aws_vpc" "main" {
  filter {
    name   = "vpc-id"
    values = [resource.aws_vpc.main.id]
  }
}
```

**Note :** data source does not have depends_on attribute

### **`depends_on`** with data source :

we can use depends_on to create dependency between data source and resource (only in rare cases when terraform can not detect the dependency automatically or value of resource is not available for data source)

**Note :** Use depends_on only when there's a hidden dependency

```bash
data "aws_vpc" "main" {
  depends_on = [resource.aws_vpc.main]
  filter {
    name   = "vpc-id"
    values = [resource.aws_vpc.main.id]
  }
}
```

## Data source in modules

```
project/
│
├── main.tf
├── variables.tf
│
└── modules/
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

For Example:

```bash
data "aws_vpc" "main" {
  tags = {
    Name = "production"
  }
}

variable "vpc_id" {
  type = string
}

module "example" {
  source = "./modules/example"
  vpc_id = data.aws_vpc.main.id
}

output "vpc_id" {
  value = module.example.vpc_id
}

```

## data source and terraform state

Data source are also represented in terraform state file but data source are not managed by terraform because :-

1. Data source are read only
2. Data source are not created by terraform
3. Data source are not updated by terraform
4. Data source are not deleted by terraform

for example:

```bash
terraform state list
```

## Data Source Examples:

1. AWS Data Source
2. Azure Data Source
3. GCP Data Source
4. Terraform Data Source

# Data Source and terraform plan/apply

```
terraform plan
      │
      ├── VPC ID unknown
      │
      └── Data source result may be deferred
                    │
                    ▼
             terraform apply
                    │
                    ▼
              VPC created
                    │
                    ▼
              Data source read
```

# Data Sources Are Provider-Specific

This means the syntax and available options for data sources can vary significantly between different cloud providers.
For example, an AWS data source like "aws_vpc" will have different attributes and arguments than an Azure data source like "azurerm_virtual_network" or a GCP data source like "google_compute_network".

**For AWS:**

```bash

data "aws_vpc" "main" {
  filter {
    name   = "vpc-id"
    values = ["vpc-123456"]
  }
}
```

**For Azure:**

```bash

data "azurerm_virtual_network" "main" {
  filter {
    name   = "virtual-network-id"
    values = ["vnet-123456"]
  }
}
```

**For GCP:**

```bash

data "google_compute_network" "main" {
  filter {
    name   = "network-id"
    values = ["network-123456"]
  }
}
```

**For kubernetes:**

```bash
data "kubernetes_service" "example" {
  filter {
    name   = "service-id"
    values = ["service-123456"]
  }
}
```

## Current AWS Region Data Sources

```bash
data "aws_region" "current" {}

output "current_region" {
  value = data.aws_region.current.name
}
```

## Availability zones Data Sources

```bash
data "aws_availability_zones" "available" {
state = "available"  #optional to filter the availability zones
}

output "available_zones" {
  value = data.aws_availability_zones.available.names
}
```

## Data sources with for_each

we can create multiple data lookups using for_each

For Example_1:

```bash

data "aws_availability_zones" "available" {}

resource "aws_instance" "example" {
  for_each = toset(data.aws_availability_zones.available.names)
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  availability_zone = each.value
  tags = {
    Name = "example-${each.value}"
  }
}
```

For Example_2:

```bash
variable "vpc_names" {
  default = [
    "development",
    "staging",
    "production"
  ]
}
data "aws_vpc" "vpcs" {
  for_each = toset(var.vpc_names)

  tags = {
    Name = each.value
  }
}

# output for the data source
output "vpcs" {
  value = data.aws_vpc.vpcs
}

# access:
data.aws_vpc.vpcs["development"].id
```

## Data sources with count

we can create multiple data lookups using count

For Example_1:

```bash

data "aws_availability_zones" "available" {}

resource "aws_instance" "example" {
  count = len(data.aws_availability_zones.available.names)
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "example-${count.index}"
  }
}
```

For Example_2:

```bash
variable "vpc_names" {
  default = [
    "development",
    "staging",
    "production"
  ]
}
data "aws_vpc" "vpcs" {
  count = length(var.vpc_names)

  tags = {
    Name = var.vpc_names[count.index]
  }
}

# output for the data source
output "vpcs" {
  value = data.aws_vpc.vpcs
}

# access:
data.aws_vpc.vpcs[0].id
data.aws_vpc.vpcs[1].id
data.aws_vpc.vpcs[2].id
```

## Data source vs Hardcoding

**_Bad approach :_**

```bash

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = "subnet-123456"
  tags = {
    Name = "example"
  }
}
```

**_good approach :_**

```bash

data "aws_subnet" "main" {
  filter {
    name   = "subnet-id"
    values = ["subnet-123456"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amz2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.main.id
  tags = {
    Name = "example"
  }
}

# This makes the configuration more dynamic.
```

### Data source security best practices

1. **Don't hardcode sensitive information**
   - Instead of hardcoding sensitive information like AMI IDs, subnet IDs, or security group IDs, use data sources to fetch them dynamically.

2. **Use filters effectively**
   - Use filters to narrow down the search results and avoid fetching unnecessary data.

3. **Use depends_on when needed**
   - Use depends_on to create dependencies between data sources and resources when needed.

4. **Use meaningful names for data sources**
   - Use meaningful names for data sources to make the configuration more readable.

5. **Use variables to make the configuration more dynamic**
   - Use variables to make the configuration more dynamic and flexible.

6. **Use outputs to make the data sources more accessible**
   - Use outputs to make the data sources more accessible and reusable.

7. **Use caching to improve performance**
   - Use caching to improve the performance of the data sources.

## Data Source vs Output

**_data source gets information from external system_**

```bash
data "aws_vpc" "main" {
  filter {
    name   = "vpc-id"
    values = ["vpc-123456"]
  }
}
```

**_output Displays/expose information_**

```bash
output "vpc_id" {
  value = data.aws_vpc.main.id
}
```

## Very Imporatant production Pattern

```bash
                AWS Account
                    │
        ┌───────────┴───────────┐
        │                       │
 Existing Infrastructure     Terraform
        │                       │
        │                  creates new
        │                  infrastructure
        │                       │
        ▼                       ▼
   Data Sources              Resources
```

For Example:

```bash

# Existing Infrastructure:
Existing:
VPC
Subnets
Route tables
IAM roles
Security groups

        ↓ data sources

Terraform

        ↓ resources

EKS
EC2
ALB
Auto Scaling
Applications
```

## Common Errors in data source

1. object does not exist
2. Multiple matches found
3. Access denied
4. Wrong region
5. Wrong filter
6. Wrong tag
7. using a resource as a data source

# Full devops-level diagram for production environment

```
                    AWS
                     │
       ┌─────────────┼─────────────┐
       │             │             │
      VPC          IAM           Route53
       │
   ┌───┴────┐
   │        │
 Subnets    SG
   │
   ▼
 Data Sources
   │
   ├── VPC ID
   ├── Subnet IDs
   ├── AMI ID
   ├── Account ID
   ├── Region
   └── IAM information
          │
          ▼
       Terraform
          │
    ┌─────┼──────┐
    ▼     ▼      ▼
   EC2    ALB    ASG
```
