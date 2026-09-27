# State Management

Terraform State is one of the most important concepts to understand before working with AWS and production infrastructure.

## What is Terraform State?

Terraform state is a JSON file that Terraform creates to store information about the resources it has created. This information includes:

- The resource type (e.g., aws_instance, aws_s3_bucket)
- The resource ID (e.g., i-1234567890abcdef0, terraform-state-bucket-7a7cc75793cd04a7)
- The resource attributes (e.g., instance type, bucket versioning)
- Secret values (if any) we assign in our terraform files

Terraform keeps information about the infrastructure it manages in a file called: **terraform.tfstate**

This information is used by Terraform to track the state of the resources it has created and to determine what needs to be done to update or destroy them.

## Why is State Management Important?

State management is important because it allows Terraform to track the state of the resources it has created and to determine what needs to be done to update or destroy them.

it records the relationship between terraform configuration files and the resources that have been created in the real world on our cloud platform.

State can contain sensitive information:
exmple:

- passwords
- api keys
- security group rules
- ssh keys
- private ip addresses of instances
- public ip addresses of instances
- dns names of instances
- etc.

### Conceptual representation of Terraform state

```
Terraform Configuration
        ↓
Terraform State
        ↓
Real Infrastructure
```

## Why is Local State Not Recommended in Production?

- **Single Point of Failure**: If the local state file is lost, Terraform loses track of all the resources it has created, making it impossible to update or destroy them.
- **Not Secure**: The local state file may contain sensitive information (e.g., passwords, API keys) that should not be stored in plain text on a local machine.
- **Not Collaborative**: The local state file is not accessible to other team members, making it difficult to collaborate on the same infrastructure.
- **No Versioning**: The local state file is not versioned, making it difficult to track changes over time.
- **No State Locking**: The local state file is not locked, making it possible for multiple users to modify the same infrastructure at the same time, which can lead to conflicts and data corruption.

## What is Backend?

Backend is a storage mechanism that is used to store the state file.

There are two types of backends:

- Local backend
- Remote backend

## Local State

it is default state management method in terraform where state file is stored in local machine

````bash
# Local State
```bash
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
````

problem with local state :

```
Developer A → own state
Developer B → own state
Developer C → own state
```

leads to drift and conflicts.

## What is Remote State?

Remote state is a state file that is stored in a remote location (e.g., S3 bucket) that can be accessed by multiple users.

```
Developer A ──┐
Developer B ──┼──> Remote State
Developer C ──┘
```

Remote backend can be AWS S3, Azure Blob Storage, Google Cloud Storage, HashiCorp Consul, etc.

## What is State Locking?

State locking is a feature that allows Terraform to lock the state file when it is being used by a user, preventing other users from modifying the same infrastructure at the same time.

- State locking prevents multiple people from modifying the same state at the same time.
- prevents concurrent operations which might lead to corrupted state files
- avoids conflicts and data corruption

DynamoDB provides state locking to prevent multiple users from modifying the same infrastructure at the same time, which can lead to conflicts and data corruption.

```
Developer A
     ↓
   LOCK 🔒
     ↓
Remote State
     ↑
Developer B
     ↓
   WAIT
```

## How to configure Remote State?

```bash
terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-7a7cc75793cd04a7"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
```

### Note

No variables are allowed in the backend configuration.

## How to migrate local state to remote state?

1. Keep the backend block commented out
2. Run terraform init
3. Apply the S3 bucket resource
4. Uncomment the backend block
5. Run terraform init -migrate-state

```bash
# Step 1: Keep the backend block commented out
# Step 2: Run terraform init
terraform init
# Step 3: Apply the S3 bucket resource
terraform apply
# Step 4: Uncomment the backend block
# Step 5: Run terraform init -migrate-state
terraform init -migrate-state
```

### Conceptual representation of State migration

```
┌────────────────────────┐              ┌────────────────────────┐
│   Local State          │              │   Remote State         │
│ (terraform.tfstate)    │              │ (S3 bucket)          │
└────────────────────────┘              └────────────────────────┘
            ↓                                       ↓
    terraform init -migrate-state             terraform init -migrate-state
            ↓                                       ↓
          Apply                                     Apply
            ↓                                       ↓
    Versioned State File                        Versioned State File
    (terraform.tfstate.backup1)                 (terraform.tfstate.backup1)
            ↓                                       ↓
         Destroy                                Destroy
```

### Important Notes

1. Backend configuration is evaluated **before** variable interpolation.
2. Use `terraform init -migrate-state` (not `terraform init`) to move state from local to remote.
3. S3 bucket versioning is enabled by default, which creates a new version of the state file for every change, allowing you to roll back to previous versions.
4. DynamoDB provides state locking to prevent multiple users from modifying the same infrastructure at the same time, which can lead to conflicts and data corruption.

## State Refresh

Terraform refresh is a command that is used to update the state file with the actual state of the resources in the cloud through comparing it with the actual state of the resources.

Modern Terraform versions automatically refresh the state file before running `terraform plan` or `terraform apply` commands. so you don't need to run `terraform refresh` command manually.

```bash
terraform refresh

terraform plan -refresh-only # update its state to reflect changes in cloud but not change the cloud resources.

```

## State Security

For state security, it is recommended to use backend configuration with state locking and encryption.

S3 state bucket should have appropriate security controls such as:

```
S3 Bucket
├── Block public access
├── Encryption
├── IAM permissions
└── Versioning
```

## Best Practices

- Always use backend configuration
- Enable versioning on the S3 bucket
- Enable encryption on the S3 bucket
- Use descriptive names for the bucket and table
- Use different S3 buckets for different environments
- Use different state files for different environments

## Examples

```bash
# Local State
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Remote State
terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-7a7cc75793cd04a7"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
```

## Three Different states of Terraform:

1. **Applied State** - The actual state of the resources in the cloud
2. **Current State** - The current state of the resources in the cloud
3. **Target State** - The desired state of the resources in the cloud

Terraform compares these states to determine what needs to be done to update or destroy the resources.

Example:

```bash
main.tf
EC2 = t3.micro
      |
Real AWS Cloud Infrastructure
EC2 = t2.micro
      |
Target State:
EC2 = t3.micro
```

## Important Notes:

1. No variables are allowed in the backend configuration. It should be plain string literals or passed via `-backend-config`.
2. Backend configuration is evaluated **before** variable interpolation.
3. Always uncomment the backend block before running `terraform init -migrate-state` to migrate state.
4. Use `terraform init -migrate-state` (not `terraform init`) to move state from local to remote.
5. S3 bucket versioning is enabled by default, which creates a new version of the state file for every change, allowing you to roll back to previous versions.
6. DynamoDB provides state locking to prevent multiple users from modifying the same infrastructure at the same time, which can lead to conflicts and data corruption.

## Troubleshooting:

- If you get an error like "Bucket already exists", it means the bucket was created in a previous run but the backend block was not uncommented or `terraform init -migrate-state` was not run.
- If you get an error like "State file not found", it means the state file was not migrated to the remote backend.

## Common Commands:

```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# Migrate state to remote backend
terraform init -migrate-state

# Reconfigure backend after changing the backend configurations
terraform init -reconfigure
```

# When to use remote state?

1. When working in a team
2. When working with production infrastructure
3. When working with state locking
4. When working with versioning
5. When working with multiple environments

# When to use local state?

1. When working with local development
2. When working with single environment
3. When working with small infrastructure

# Remote state vs local state

Remote state is stored in a remote location (e.g., S3 bucket) that can be accessed by multiple users.
Local state is stored in a local file that can only be accessed by the user who created it.

### Remote State: Pros

- **Collaboration**: Multiple team members can access and work with the same state file
- **Security**: State file is stored in a secure location (e.g., S3 bucket) with encryption
- **Versioning**: State file is versioned, allowing you to roll back to previous versions
- **State Locking**: Prevents multiple users from modifying the same infrastructure at the same time

### Local State: Pros

- **Simplicity**: Easy to set up and use
- **No Dependencies**: No need for S3 bucket or DynamoDB table
- **Quick for Local Development**: Good for small projects and local development

### Remote State: Cons

- **More Complex Setup**: Requires S3 bucket and DynamoDB table
- **More Dependencies**: Requires AWS access and permissions
- **More Complex Troubleshooting**: More places to look for issues

### Local State: Cons

- **Not Collaborative**: Only one user can access and work with the state file
- **Less Secure**: State file is stored in a local file that can be easily accessed
- **No Versioning**: State file is not versioned, making it difficult to roll back to previous versions
- **No State Locking**: Multiple users can modify the same infrastructure at the same time, which can lead to conflicts and data corruption

# Terraform State File Commands

| Command                              | Description                                             |
| ------------------------------------ | ------------------------------------------------------- |
| `terraform state list`               | Lists all resources in the state file                   |
| `terraform state mv`                 | Moves a resource to a different name or location        |
| `terraform state remove`             | Removes a resource from the state file                  |
| `terraform state mv -dry-run`        | Shows what would happen if the command were run         |
| `terraform state replace-provider`   | Replaces a provider with another provider               |
| `terraform state mv -ignore-missing` | Ignores missing resources during move operation         |
| `terraform state mv -no-backup`      | Prevents backup of the state file during move operation |
| `terraform state push`               | Pushes the local state file to the remote backend       |
| `terraform state pull`               | Pulls the remote state file to the local backend        |

## Examples of Terraform State File Commands

```bash
# List all resources in the state file
terraform state list

# show state
terraform state show <resource-name>

ex:- terraform state show random_pet.example


# Move a resource to a different name or location
terraform state mv <old-name> <new-name>

# Remove a resource from the state file not actually real infrastructure delete
terraform state remove <resource-name>

# Show what would happen if the command were run
terraform state mv -dry-run <old-name> <new-name>

# Replace a provider with another provider
terraform state replace-provider <old-provider> <new-provider>

# Ignore missing resources during move operation
terraform state mv -ignore-missing <old-name> <new-name>

# Prevent backup of the state file during move operation
terraform state mv -no-backup <old-name> <new-name>

# Push the local state file to the remote backend /upload to remote backend
terraform state push

# Pull the remote state file to the local backend /download from remote backend
terraform state pull > temp.tfstate
```

### Note: `state mv` , `state remove` and `state push` will work only with local state files not with remote state files. Should be used carefully with remote state files.

# Common Commands

## **Note: Use `terraform init -migrate-state` instead of `terraform init` when migrating from local to remote state**

| Command                              | Description                                                        | Example                              |
| ------------------------------------ | ------------------------------------------------------------------ | ------------------------------------ |
| `terraform init`                     | Initializes Terraform and downloads providers                      | `terraform init`                     |
| `terraform init -migrate-state`      | Initializes Terraform and migrates state to remote backend         | `terraform init -migrate-state`      |
| `terraform init -reconfigure`        | Reconfigures the backend after changing the backend configurations | `terraform init -reconfigure`        |
| `terraform plan`                     | Plans the changes to be made to the infrastructure                 | `terraform plan`                     |
| `terraform apply`                    | Applies the changes to the infrastructure                          | `terraform apply`                    |
| `terraform destroy`                  | Destroys the infrastructure                                        | `terraform destroy`                  |
| `terraform state list`               | Lists all resources in the state file                              | `terraform state list`               |
| `terraform state mv`                 | Moves a resource to a different name or location                   | `terraform state mv`                 |
| `terraform state remove`             | Removes a resource from the state file                             | `terraform state remove`             |
| `terraform state mv -dry-run`        | Shows what would happen if the command were run                    | `terraform state mv -dry-run`        |
| `terraform state replace-provider`   | Replaces a provider with another provider                          | `terraform state replace-provider`   |
| `terraform state mv -ignore-missing` | Ignores missing resources during move operation                    | `terraform state mv -ignore-missing` |
| `terraform state mv -no-backup`      | Prevents backup of the state file during move operation            | `terraform state mv -no-backup`      |
| `terraform state push`               | Pushes the local state file to the remote backend                  | `terraform state push`               |
| `terraform state pull`               | Pulls the remote state file to the local backend                   | `terraform state pull`               |

# Production Architecture

```bash
                 Git Repository
                       │
                       ↓
                 Terraform Code
                       │
                       ↓
                  CI/CD Pipeline
                       │
                       ↓
                    Terraform
                       │
                       ↓
              ┌─────────────────┐
              │   Amazon S3     │
              │                 │
              │ terraform.tfstate
              │      +          │
              │    lockfile     │
              └─────────────────┘
                       │
                       ↓
                AWS Infrastructure
```
