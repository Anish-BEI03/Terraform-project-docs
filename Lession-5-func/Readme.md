# Terraform -> Count, For_each Expression and Functions

## To create multiple resources:

- we use count and for_each meta arguments.

## Why Do We Need Count and For_each ?

1. creating multiple instances of same resource with different config.
2. Ex: we want to create 3 ec2 instances with different ports.
   - without count and for_each, we have to create 3 ec2 instances with different configurations.
   - with count and for_each, we can create 3 ec2 instances with a single configuration.

3. Count and for_each are meta-arguments, that means they are not arguments, but they are arguments that are used to create multiple resources.

## Terraform Meta-Arguments:

Meta-arguments in Terraform are special configuration-level features that control how Terraform manages our infrastructure resources

| Meta-Argument | Description                                                                        |
| ------------- | ---------------------------------------------------------------------------------- |
| - count       | Used to create multiple instances of a resource based on a numeric count.          |
| - for_each    | Used to create multiple instances of a resource based on a set of strings or maps. |
| - depends_on  | Used to specify dependencies between resources.                                    |
| - lifecycle   | Used to control the lifecycle of a resource.                                       |
| - provider    | Used to specify the provider for a resource.                                       |
| - providers   | Used to specify the providers for a resource.                                      |

## Common Syntax:

```terraform
resource "<resource_type>" "<resource_name>" {
  count = 3
  name = "<resource_name>"-${count.index}
}
```

## Count:

- used to create multiple instances of a resource based on a numeric count.
- syntax: count = 5
- starts from 0.
- count.index can be used to access the index of the resource.

```bash
resource "local_file" "example" {
  count = 3

  filename = "file-${count.index}.txt"
  content  = <<-EOF
  Terraform file" ${count.index}
  Server ${count.index}
  IP Address : 192.168.${count.index}.1

EOF
}
```

```bash
1. terraform apply

2. terraform destroy
```

### using count with variable

**_varialbe.tf_**

```bash
variable "count" {
  type    = number
  default = 3
}
```

**_main.tf_**

```bash
resource "local_file" "server" {
  count = var.server_count

  filename = "server-${count.index}.txt"
  content  = "Server ${count.index}"
}
```

**_ Command line : _**

```bash
1. terraform apply

2. terraform destroy
```

#### Accessing count resources:

A resource using count becomes a collection.

```
local_file.server[0]
local_file.server[1]
local_file.server[2]
```

**_output.tf_**

```bash
output "count_resources" {
  value = local_file.server[*].filename # show all values of the resource
}

output "count_resources_indexed" {
  value = local_file.server[1].filename # show specific values of the resource
}
```

#### Problem with count:

- if we add a new resource in between, the index of the resources will change.
- Ex: if we have 3 resources and we add a new resource in between, the index of the resources will change from 0, 1, 2 to 0, 2, 3.

Example :

```
servers = [web, db, cache, redis]
```

and use `count = length(var.servers)`

Terraform identifies resources by index.
Ex

```
server[0]
server[1]
server[2]
server[3]
```

we remove second resource -> db

```
server[0]  web
server[1]  db  <-- deleted
server[2]  cache
server[3]  redis

After delete:
server[0]  web
server[1]  cache
server[2]  redis
```

This is a problem because the index of the resources will change.

# For_each:

## (usind set and map and list variable type) -> best for create multiple resources (dynamic) than count:

- used to create multiple instances of a resource based on a set of strings or maps.
- syntax: for_each = ["a", "b", "c"]
- starts from 0.
- for_each.index can be used to access the index of the resource.

### Example: use toset() function in for_each

```bash
resource "local_file" "example" {
  #for_each = toset(["a", "b", "c"])

  for_each = toset([
  "web",
  "db",
  "cache",
  "redis"
  ])


  filename = "file-${each.key}.txt"
  content  = "File ${each.key}"
}
```

Terraform identifica them by keys, so if we remove a resource, the index of the resources will not change.

#### using state command:

local_file.servers["cache"]
local_file.servers["db"]
local_file.servers["redis"]
local_file.servers["web"]

#### Note : using each.key and each.value with a set represent same elementa.

## Example : using for_each with a tomap() variable type

**_ variable.tf _**

```
variable "servers" {
  type = map(string)
}
```

**_ main.tf _**

```
resource "local_file" "servers" {
  for_each = var.servers

  filename = "${each.key}.txt"
  content  = "${each.value}"
}
```

**_ terraform.tfvars _**

```
servers = {
  "web" = "web server"
  "db" = "database to host mysql"
  "cache" = "cache server"
  "redis" = "redis server"
}
```

**_ output.tf _**

```
output "servers" {
  value = [
    for key,val in local_file.servers :
    "${val.filename} -> ${val.content}"
  ]
}
```

## Count vs For-each:

| count                                | for_each                                 |
| ------------------------------------ | ---------------------------------------- |
| Uses indexes                         | Uses keys                                |
| count.index                          | each.key                                 |
| Good for identical resources         | Good for uniquely named resources        |
| Numeric collection                   | Set/map                                  |
| Index changes can cause replacements | Stable keys are usually easier to manage |

### Note:

- when creating resource using `count` or `for_each `-> the `index` or `key` is used to identify the resource.

# Terraform Exprssions:

Terraform expressions are used to evaluate dynamic values in our Terraform configuration.

Our configuration tell's to the terraform that what infrastructure we want to create.

Terraform supports expressions for calculating values.

## Types of Expressions:

1. Values
2. Variables
3. Resource Attributes
4. Functions
5. Interpolation

## Example:

**_ using conditional (ternary) operator: _**

** syntax: **

```bash
variable = <condition> ? <value_if_true> : <value_if_false>
```

**_ Example: _**

```bash

instance_type = var.environment == "production"
  ? "t3.medium"
  : "t3.micro"
```

if production -> t3.medium
else -> t3.micro

### For expression:

Terraform's for expression allows we to create a new collection of values based on an existing collection.

** syntax: **

```bash
variable = [ for item in collection : transformation ]
```

** Example: **

**_ variable.tf _**

```bash
variable "names" {
  default = [
    "docker",
    "kubernetes",
    "terraform"
  ]
}
```

**_ Create uppercase values _**

```
locals {
  upper_names = [
    for name in var.names : upper(name)
  ]
}
```

**_ output.tf _**

```bash
output "upper_names" {
  value = local.upper_names
}
```

## Filtering With for

suppose:

```bash

variable "numbers" {
  default = [1, 2, 3, 4, 5, 6]
}

# Filtering with for expression: only even numbers
locals {
  even_numbers = [ for num in var.numbers : num
  if num % 2 == 0
  ]
}
```

### Nested For Expression:

Nested for expression is used to create a nested collection of values based on an existing collection.

#### Syntax:

```bash
variable = [
  for outer_item in outer_collection :
    [for inner_item in inner_collection : transformation]
]
```

#### Example:

```bash
variable "environments" {
  default = [
    {
      name = "prod"
      tags = ["prod"]
    },
    {
      name = "dev"
      tags = ["dev"]
    }
  ]
}

locals {
  all_names = [
    for env in var.environments : env.tags  # only return tags
  ]


  all_names_flat = [
    for env in var.environments :
    [for tag in env.tags :
      "${env.name}-${tag}"
    ]
  ]
}

```

# Terraform Functions:

Terraform functions are used to perform operations on values in our Terraform configuration.

Terraform has many built-in functions.

## Types of Functions:

Important Functions:

1. count() - creates a list of values based on the count.
2. for_each() - creates a map of values based on the for_each.
3. upper() - converts a string to uppercase.
4. lower() - converts a string to lowercase.
5. trim() - removes leading and trailing whitespace from a string.
6. length() - returns the length of a list or string.
7. concat() - concatenates two lists or strings.
8. join() - joins a list of strings into a single string.
9. split() - splits a string into a list of strings.
10. lookup() - looks up a value in a map.
11. merge() - merges two maps.
12. contains() - checks if a list contains a value.
13. toset() - converts a list to a set.
14. tolist() - converts a set to a list.
15. tomap() - converts a set to a map.

### Example: lookup() in map

```bash
variable "servers" {
  type = map(string)
}


#terraform.tfvars


servers = {
  "web" = "web server"
  "db" = "database to host mysql"
  "cache" = "cache server"
  "redis" = "redis server"
}

locals {
  server = lookup(var.servers, "web", "default")
}

# syntax
# lookup(map, key, default)

```

### Example: merge() in map

```bash
locals {
  common_tags = {
    project = "devops"
  }

  environment_tags = {
    environment = "production"
  }

  tags = merge(
    local.common_tags,
    local.environment_tags
  )
}
```

# Dynamic Block :

Advanced but important concept to learn

Dynamic block is used to create a block of code that can be repeated multiple times.

** syntax: **

```bash
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  dynamic "ebs_block_device" {
    for_each = var.volumes

    content {
      device_name = ebs_block_device.value.device_name
      volume_size = ebs_block_device.value.volume_size
    }
  }
}
```

```bash
# Terraform Dynamic Block

# scenario: you want to attach multiple EBS volumes to an EC2 instance.
# instead of hard-coding each volume, you use a dynamic block.

variable "volumes" {
  description = "A list of EBS volumes to attach to the instance."
  type = list(object({
    device_name = string
    volume_size = number
  }))
  default = [
    { device_name = "/dev/sdf" , volume_size = 20 },
    { device_name = "/dev/sdg" , volume_size = 30 }
  ]
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  dynamic "ebs_block_device" {
    for_each = var.volumes

    content {
      device_name = ebs_block_device.value.device_name
      volume_size = ebs_block_device.value.volume_size
    }
  }
}
```

## Basic Idea:

```bash
variable ->  for_each  -> dynamic -> multiple nested blocks

```

**Note:** Dynamic blocks are very powerful and can be used to create complex configurations.

# Importance picture :

```bash

                    Terraform
                        │
        ┌───────────────┼────────────────┐
        ▼               ▼                ▼
     Variables        Locals          Functions
        │               │                │
        └───────────────┼────────────────┘
                        ▼
                   Expressions
                        │
              ┌─────────┴─────────┐
              ▼                   ▼
            count              for_each
              │                   │
              └─────────┬─────────┘
                        ▼
                    Resources
                        │
                        ▼
                 Infrastructure

```
