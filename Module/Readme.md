# Terraform Modules: -> Importance for DevOps Engineer -> Template of Infra Structure Code

A module is a container for multiple resources that are used together.

A Terraform module is a reusable collection of Terraform configuration files used to create and manage infrastructure in a structured and repeatable way.

A module is a reusable collection of Terraform configuration files.

-> Instead of writing the same Terraform code again and again, we create it once as a module and reuse it.

Example:

```bash
Without module:
main.tf
  ├── VPC code
  ├── Subnet code
  ├── Security Group code
  └── EC2 code

With module:
main.tf
  ├── VPC module
  ├── Security Group module
  └── EC2 module

```

## Importance:

1. Reusability:
   - write once, use everywhere
2. Consistency:
   - all environments get the same configuration
3. Organization:
   - divide large infrastructure into smaller pieces
4. Collaboration:
   - teams can work on different modules independently
5. Less duplicate code
6. Easy maintenance
7. Standard infrastructure
8. Production infrastructure design

Terraform have two types of modules:

1. Root Module:
   - Root module is the main module that is used to create the infrastructure.
   - Every Terraform project has a root Module.
   - It is the entry point of the Terraform configuration.

```bash
 terraform-project/                  <- Root module
 ├── main.tf
 ├── variables.tf
 └── outputs.tf

```

2. Child Module:
   - Child module is a module that is used to create the infrastructure.
   - If the root module calls another module, that is a child module.

   ```bash
   terraform-project/   <----- child module
   ├── main.tf
   ├── variables.tf
   └── outputs.tf
   ├── modules/      <-- all root modules
   │   ├── vpc/
   │   │   ├── main.tf
   │   │   ├── variables.tf
   │   │   └── outputs.tf
   │   ├── ec2/
   │   │   ├── main.tf
   │   │   ├── variables.tf
   │   │   └── outputs.tf
   │   └── rds/
   │       ├── main.tf
   │       ├── variables.tf
   │       └── outputs.tf
   └── outputs.tf
   ```

# Creating Custom Module in Terraform

1. Supose we create a server module.

```bash
terraform-project/
├── main.tf
├── variables.tf
└── outputs.tf
├── modules/
│   └── server/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

2. Create the server module.

```bash
mkdir modules/server
cd modules/server
touch main.tf
touch variables.tf
touch outputs.tf
```

3. Write the code for the server module.

modules/server/main.tf

```bash
#main.tf
 resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
```

4. Write the variables for the server module.

modules/server/variables.tf

```bash
#variables.tf
variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
}

variable "instance_name" {
  description = "Instance Name"
  type        = string
}
```

5. Write the outputs for the server module.

modules/server/outputs.tf

```bash
#outputs.tf
output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.example.id
}
```

# Calling the module from the root module.

main.tf

```bash
module "server" {
  source = "./modules/server"

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  instance_name = "example"
}
```

variables.tf

```bash
#variables.tf
variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
}

variable "instance_name" {
  description = "Instance Name"
  type        = string
}
```

outputs.tf

```bash
#outputs.tf
output "instance_id" {
  description = "Instance ID"
  value       = module.server.instance_id
}
```

# Calling the multiple root modules in main.tf

```bash
#main.tf
module "server1" {
  source = "./modules/server"

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  instance_name = "example1"
}

module "server2" {
  source = "./modules/server"

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  instance_name = "example2"
}
```

### main idea

modules are used to create reusable infrastructure.

Input -> Module -> Resource -> Output

# Module can call other modules.

main.tf

```bash
module "server1" {
  source = "./modules/server"

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  instance_name = "example"
}
```

modules/vpc/main.tf

```bash
module "server2" {
  source = "./modules/server"

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  instance_name = "example2"
}
```

# Important Module Concepts:

1. Module can call other modules.
2. Module can call itself.
3. Module can be called multiple times.
4. Module can be called from different environments.
5. Module can be called from different accounts.
6. Module can be called from different regions.
7. Module can be called from different providers.
8. Module can be called from different projects.
9. Module can be called from different organizations.
10. Module can be called from different accounts and different regions and different providers.

# Important Module Concepts

| Concept         | Meaning                        |
| --------------- | ------------------------------ |
| module          | "Calls a Module"               |
| source          | "Location of the module"       |
| name            | "Name of the module"           |
| Input variables | Data sent into module          |
| Outputs         | Data returned from module      |
| Root module     | Main Terraform project         |
| Child module    | Module called by root module   |
| Public module   | Module from Terraform Registry |
| Local module    | Module stored in your project  |
