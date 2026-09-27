# Terraform - Variables, tfvars, Output,Input and Loacals

Now we move from hard-coded terraform to re-usable terraform code.

## Main idea

```
Hard-coded values
       ↓
Variables
       ↓
Reusable Terraform code
```

# Why Do we Need variable?

Suppose hard code values in terraform code.

For example if we have AMI ID, instance type, region, etc. Then we need to change the values in all the files where the values are used. This is not a good practice. So we use variables to store the values. Then we can change the values in one file and the values will be updated in all the files where the values are used.

```
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "devops"
  }
}
```

### Another example

```
resource "local_file" "example" {
  filename = "dev.txt"
  content  = "Development"
}
```

#### Now we want change file name from

```
dev.txt --> prod.txt
staging.txt
qa.txt
```

#### and content from

```
Development --> Production
Staging --> Staging
QA --> QA
```

#### Using Variables

```
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.name
  }
}
```

#### Using Variables in Terraform Code

Instead of creating three different configurations, use a variable.

```
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.name
  }
}
```

### OR

```
resource "local_file" "example" {
  filename = var.filename
  content  = var.environment
}
```

## Variables

- Variables in terraform are used to store values that can be used in terraform code.
- Variables make terraform code reusable.
- Variables are declared in a `variables.tf` file.
- Variables are used in a terraform code using the `var` keyword.
- Example:- `var.variable_name`
- Variables can be passed to terraform code in several ways:
  1. By using the `var` keyword in the terraform code.
  2. By using the `variable` block in the terraform code.
  3. By using the `tfvars` file in the terraform code.
  4. By using the command line arguments in the terraform code.
  5. By using the environment variables in the terraform code.

## Types of Variables

Terraform supports the following types of variables:

1. String

```bash
variable "environment" {
  type = string
}
```

2. Number

```bash
variable "count" {
  type = number
}
```

3. Boolean

```bash
variable "enabled" {
  type = boolean
}
```

4. List

```bash
variable "names" {
  type = list(string)
}
```

5. Map

```bash
variable "config" {
  type = map(string)
}
```

6. Object

```bash
variable "user" {
  type = object({
    name = string
    age  = number
  })
}
```

### Creating Variables

- Variables are declared in a `variables.tf` file.
- Example:- `variable.tf`

```bash
# Syntax:
variable "variable_name" {
  type        = "string"
  description = "Description of the variable"
  default     = "default_value"
}

```

## Example

```bash
variable "Instace_type" {
  type        = "string"
  description = "EC2 Instance Type"
  default     = "t2.micro"
}

variable "region" {
  type        = "string"
  description = "Description of the variable"
  default     = "ap-south-1"
}

variable "AMI_ID" {
  type        = "string"
  description = "AMI ID"
  default     = "ami-0c55b159cbfafe1f0"
}
```

### Then use it in main.tf

```bash
resource "aws_instance" "example" {
  ami           = var.AMI_ID
  instance_type = var.Instace_type
  region        = var.region

  tags = {
    Name = "devops"
  }
}
```

```bash
# Note
# In HCL (HashiCorp Configuration Language),
# variable access inside terraform code
${var.variable_name}

or

var.variable_name
```

### means :- ${ } is nothing but expression in hcl language

```
var --> keyword
 ↓
variable --> block name
 ↓
filename --> attribute name
```

# List type varible

A list contains multiple values.

```bash
variable "course" {
 type = list(string)
 description = "List of courses"
 default = [
   "Terraform",
   "Docker",
   "Kubernetes",
   "Jenkins",
   "Ansible"
 ]

}
```

### Example:

```
course = [
  "Terraform",
  "Docker",
  "Kubernetes",
  "Jenkins",
  "Ansible"
]

```

#### Accessing List Values

Terraform list indexing starts at 0.

```
var.course[0]   # Terraform
var.course[1]   # Docker
var.course[2]   # Kubernetes
var.course[3]   # Jenkins
var.course[4]   # Ansible

```

# Set type variable

A set contains multiple/collection of unique values.
A set does not preserve duplicate values.

```bash
variable "tools" {
  type = set(string)
  description = "Set of tools"
  default = [
    "Terraform",
    "Docker",
    "Kubernetes",
    "Jenkins",
    "Ansible"
  ]
}
```

#### Accessing Set Values

```
var.tools[0]   # Terraform
var.tools[1]   # Docker
var.tools[2]   # Kubernetes
var.tools[3]   # Jenkins
var.tools[4]   # Ansible
```

#### Example:

```
tools = {
  "Terraform",
  "Docker",
  "Kubernetes",
  "Jenkins",
  "Ansible"
}
```

# Map type variable

A map contains key-value pairs.

```bash
variable "ports" {
  type = map(string)
  description = "Map of ports"
  default = {
    "HTTP" = "80"
    "HTTPS" = "443"
    "SSH" = "22"
    "RDP" = "3389"
    "FTP" = "21"
  }
}
```

#### Access Map Values

```
var.ports["HTTP"]   # 80
var.ports["HTTPS"]  # 443
var.ports["SSH"]    # 22
var.ports["RDP"]    # 3389
var.ports["FTP"]    # 21
```

#### Example

```
ports = {
  "HTTP" = "80"
  "HTTPS" = "443"
  "SSH" = "22"
  "RDP" = "3389"
  "FTP" = "21"
}
```

# Object type variable

An object contains a map of values.
Objects are very useful in larger Terraform projects.

```bash
variable "server" {
  type = object({
    name = string
    cpu  = number
    ram  = number
    disk = number

  })
  default = {
    name = "Web-server"
    cpu  = 2
    ram  = 4
    disk = 100
  }
}
```

#### Access Object Values

```
var.server.name   # Web-server
var.server.cpu    # 2
var.server.ram    # 4
var.server.disk   # 100
```

#### Example

```
server = {
  name = "Web-server"
  cpu  = 2
  ram  = 4
  disk = 100
}
```

# variable Default Value

- Default value is the value that is assigned to a variable if no value is provided for the variable.

```bash
variable "environment" {
  type    = string
  default = "dev"
}
```

Now if you don't provide a value, Terraform uses:

```
dev
```

# Required variable Values

- Terraform required block is used to set the variable values in terraform code.

1. Environment variables
2. Command line arguments
3. Terraform.tfvars file
4. Terraform.auto.tfvars file
5. Module default values

if we not provided any value to the variable then it willexpects you to provide a value.

You may be prompted: "Enter value for environment: " (during terraform apply) or using -var flag or using tfvars file.

Example:

```bash
variable "environment" {
  type    = string
  description = "Name of the variable"
}
```

You may be prompted: "Enter value for environment: "

```
var.environment
  Enter a value:

```

(during terraform apply) or using -var flag or using tfvars file.

# terraform.tfvars

File name must be `terraform.tfvars` or `terraform.auto.tfvars`.

This is one of the most important files for variables.

Example:

```bash
variable "environment" {
  type    = string
  default = "dev"
}
```

1. create:

```bash
create: terraform.tfvars
```

2. in terraform.tfvars file:

```bash

filename = "devops.txt"
environment = "development"

```

#### Terraform automatically loads values from : terraform.tfvars and terraform.auto.tfvars files

```bash
terraform.tfvars
terraform.auto.tfvars
```

# variable Precedence

Terraform can receive variable values from multiple places.

1. Default value
2. terraform.tfvars
3. \*.auto.tfvars
4. Environment variables
5. -var
6. -var-file

For Example:

1. using -var flag

```bash
terraform plan -var="environment=production" -var="env=production"
--------------------------------
Output:

Environment: production
env : production
```

2. using -var-file flag

```bash
terraform plan -var-file="prod.tfvars"
----------------------------------
Output:

Environment: production
env : production
----------------------------------
```

# Terraform Output

Outputs are used to display values from terraform code.

Variables provide input to terraform code. Outputs provide output from terraform code.

### Syntax of output

```bash
output "output_name" {
  value = terraform_resource.resource_name.attribute_name
}
```

#### Main Idea

```
INPUT
  ↓
Variables
  ↓
Terraform
  ↓
Resources
  ↓
OUTPUT
  ↓
Outputs
```

Example:

1. create values.tf

```bash
variable "environment" {
  type = string
}
```

2. create output.tf

```bash
output "environment" {
  value = var.environment
}
```

3. create main.tf

```bash
resource "local_file" "example" {
  filename = "example.txt"
  content  = var.environment
}
```

### when execute terraform output command

```bash
terraform output

───────────────────────────────────────────────────────────────────────────────

Output:

filename = "devops.txt"
content  = "devops"
--------------------------------
```

## Why we need output in terraform?

1. To display the values of variables in terraform code.
2. To display the values of resources in terraform code.
3. To display the values of outputs in terraform code.

Example : imagine AWS create an ec2 instance

```
EC2
 ├── ID
 ├── Public IP
 ├── Private IP
 └── DNS

```

Expose the Public IP and DNS Name

```bash
output "EC2-ID" {
  value = aws_instance.example.id
}

output "Public-IP" {
  value = aws_instance.example.public_ip
}

output "Private-IP" {
  value = aws_instance.example.private_ip
}


output "DNS-Name" {
  value = aws_instance.example.dns_name
}
```

```bash
output:

───────────────────────────────────────────────────────────────────────────────

EC2-ID = "i-0123456789abcdef0"
Public-IP = "[IP_ADDRESS]"
Private-IP = "[IP_ADDRESS]"
DNS-Name = "ec2-54-123-456-789.compute-1.amazonaws.com"
```

# Sensative output:

suppose an output value is sensative or secret value
Example:

```bash
output "sensative_output" {
  value     = var.password
  sensitive = true
}
```

### Terraform will avoid displaying the actual value in normal output.

### But remember:

- `sensitive = true` does not magically encrypt the value in Terraform state.

### This is why state security is extremely important.

```bash
terraform output

───────────────────────────────────────────────────────────────────────────────

Output:
sensative_output = [PASSWORD]
```

# Locals

Locals are used to define local values in terraform code.
Locals are very useful in larger Terraform projects.

Locals are useful for values that we calculate or reuse inside our configuration.

#### Syntax

```bash
locals {
  local_name = value
}
```

Example:

```bash
locals {
  project_name = "devops"
  environment  = "development"

  full_name = "${local.project_name}-${local.environment}"
}
```

Use:

```bash
local.full_name
```

Output:

```
devops-development
```

Locals are commonly used for:

- Naming resources
- Setting defaults
- Combining different values
- Making complex expressions easier to read

### Notice the diff between variable and locals

var.name ->means-> input to terraform code
locals.name ->means-> local value calculated from terraform code

### variable vs locals

| Variable                  | Local                                                                       |
| ------------------------- | --------------------------------------------------------------------------- |
| Input                     | Computed / calculation/internel reusable value                              |
| User or Environment       | Terraform code                                                              |
| Precede the configuration | Defined inside the configuration                                            |
| user can provide values   | we cannot override / change computed / calculation/internel reusable values |
| define in variable.tf     | define in locals.tf                                                         |
| syntax: var.name          | syntax: locals.name                                                         |

#### Example:

```bash
variable "environment" {
  type    = string
  default = "dev"
}

variable "env" {
  type = string
}

locals {
  full_name = "myapp-${var.environment}-${var.env}"
}
```

#### Output

```
local_name = "myapp-dev-development"
```
