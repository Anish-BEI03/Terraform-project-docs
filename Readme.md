# What is Infrastructure as Code (IaC)?

In traditional operations, we use to manage the servers, networking, storage and other components of the infrastructure manually. This was a time consuming and error prone process.

Instead of manually creating:

EC2 servers
VPCs
Networks
Databases
Kubernetes resources
Load balancers

Problems with Manual Provisioning:

1. Time consuming : It takes more time to provision and manage the infrastructure manually. Also it require more human efforts to do the same.
2. Error prone and human errors : Since the infrastructure is managed manually, there are more chances of human errors which can lead to downtime and other issues.
3. Lack of consistency across environments : Since the infrastructure is managed manually, there are more chances of inconsistency across environments. This can lead to issues with application deployment and performance.
4. Not scalable : Since the infrastructure is managed manually, it is not scalable. This means that we cannot scale the infrastructure to meet the growing needs of the application.
5. Not version controlled : Since the infrastructure is managed manually, it is not version controlled. This means that we cannot track the changes made to the infrastructure and roll back to a previous version if needed.
6. Configuration Drift : When infrastructure is modified manually, the actual configuration deviates from the intended configuration. This can lead to issues with application deployment and performance.
7. Security : Since the infrastructure is managed manually, there are more chances of security vulnerabilities.
8. Compliance : Since the infrastructure is managed manually, it is difficult to ensure compliance with regulatory requirements.
9. DR and Backups : Since the infrastructure is managed manually, it is difficult to ensure proper DR and backups.
10. Slow and no-repeatable : Since the infrastructure is managed manually, it is slow and not repeatable.

# What is Infrastructure as Code (IaC)?

Infrastructure as Code (IaC) is the process of managing and provisioning infrastructure through code and machine-readable definition files, rather than through manual processes or interactive tools. This allows you to version, test, and deploy infrastructure just like you would with application code.

It is a declaritive configuration language for creating, updating, and destroying cloud and on-premise resources in a safe, efficient, and predictable manner.

```h
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

resource "local_file" "My_file"{
filename = "test.txt"
content = "This is a test file created by terraform."
}

Explanation:

1. resource : Block which is used to define the infrastructure.
2. local_file : Type of the resource which is used to define the local file.
3. My_file : Name of the resource.
4. filename : Parameter that defines the name of the file.
5. content : Parameter that defines the content of the file.

Terraform reads this configuration and creates the EC2 instance.

# What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool used to create, configure, and manage infrastructure using code.

Terraform solves this by defining servers, networks, databases, and policies in declarative configuration files that can be versioned, tested, and automated.

Key features of Terraform

1. Declarative Configuration : Terraform uses a declarative configuration language, HCL (HashiCorp Configuration Language), to define the desired state of the infrastructure.
2. Provider Ecosystem : Terraform has a rich ecosystem of providers that allow you to manage infrastructure across different cloud providers and services.
3. State Management : Terraform maintains a state file that keeps track of the infrastructure resources and their current state.
4. Module System : Terraform allows you to organize your infrastructure code into reusable modules.
5. Plan and Apply Workflow : Terraform uses a plan and apply workflow to manage infrastructure changes.
6. Remote State Management : Terraform allows you to store the state file in a remote backend, such as S3, which allows you to share the state file with your team and manage the state file in a secure manner.
7. Locking : Terraform uses locking to prevent multiple users from modifying the state file at the same time.
8. Workspace : Terraform allows you to manage different environments, such as development, testing, and production, using workspaces.
9. CLI (Command Line Interface) : Terraform provides a CLI that allows you to interact with the infrastructure and manage the state file.
10. Versioning : Terraform allows you to version your infrastructure code, which allows you to track changes and revert to previous versions if needed.
11. Plan : Terraform uses a plan command to show the changes that will be made to the infrastructure.
12. Apply : Terraform uses an apply command to create or update the infrastructure.
13. Destroy : Terraform uses a destroy command to remove the infrastructure.

# Terraform vs Traditional Provisioning

| Feature                 | Terraform   | Traditional Provisioning |
| ----------------------- | ----------- | ------------------------ |
| Configuration           | Declarative | Imperative               |
| State Management        | Yes         | No                       |
| Module System           | Yes         | No                       |
| Plan and Apply Workflow | Yes         | No                       |
| Provider Ecosystem      | Yes         | No                       |

---

## Terraform vs Aws CloudFormation

Both Terraform and CloudFormation are industry-leading IaC tools, but they cater to different architectural strategies.

| Feature/criteria                | HashiCorp Terraform/OpenTofu                                                                                                                                              | Aws CloudFormation                                                                                                              |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| Creator / Ecosystem             | HashiCorp (Open Source / Business License & OpenTofu)                                                                                                                     | Amazon Web Services (AWS Native)                                                                                                |
| Supported Providers             | Multi-cloud (AWS, Azure, GCP, etc.), SaaS, and on-premise                                                                                                                 | AWS-native resources only                                                                                                       |
| Configuration Language          | HCL (HashiCorp Configuration Language) or JSON                                                                                                                            | CloudFormation JSON or YAML                                                                                                     |
| State Management                | Maintains state files locally or in remote backends (S3, Consul, etc.) /Explicit Client-Side State: Stores metadata in terraform.tfstate (locally or in remote S3 bucket) | Uses S3 buckets for state storage (Legacy) /Managed Server-Side State: AWS handles stack state automatically behind the scenes. |
| Execution plan (dry Run)        | terraform plan previews exact additions (+), modifications (~), and destructions (-).                                                                                     | CloudFormation Change Sets (requires generating and reviewing in console/CLI).                                                  |
| Modularity & Reusability        | First-class support for reusable modules via public/private registries or Git.                                                                                            | CloudFormation Nested Stacks and AWS CDK constructs.                                                                            |
| Rollback Behavior               | Does not auto-rollback on failure; records partial state so you can fix code and re-apply.                                                                                | Automatically rolls back entire stack if a resource creation fails (can sometimes get stuck in UPDATE_ROLLBACK_FAILED).         |
| Installation & Access           | Open Source, freely downloadable. Can be run from any machine with access to cloud APIs                                                                                   | Built-in AWS service; no additional installation required                                                                       |
| Execution Model                 | Imperative-like with declarative syntax (describes the desired end state)                                                                                                 | Strictly declarative (describes the desired end state)                                                                          |
| CI/CD Integration               | Excellent; can be integrated with any CI/CD pipeline                                                                                                                      | Seamless integration with AWS CodePipeline and other AWS tools                                                                  |
| Version Control                 | Works with local Git repositories for version control of code                                                                                                             | Requires proper AWS S3 bucket versioning setup for state version control                                                        |
| Community & Ecosystem           | Large open-source community with extensive third-party provider support                                                                                                   | Primarily relies on AWS documentation and support; some third-party integrations                                                |
| Learning Curve                  | Relatively easy for those familiar with JSON/HCL; intuitive workflow                                                                                                      | Moderate; requires understanding of CloudFormation templates and AWS services                                                   |
| Cross-Cloud Capabilities        | Excellent; single codebase can manage resources across multiple cloud providers                                                                                           | Not applicable; limited to AWS services only                                                                                    |
| Extensibility                   | Rich provider ecosystem and custom provider development capabilities                                                                                                      | Limited to AWS-defined resource types; custom resources can be created via Lambda                                               |
| Speed of Cloud Feature Adoption | Often releases day-0 support for AWS features via the open-source AWS provider community.                                                                                 | Native AWS support, but sometimes lags behind new AWS service releases.                                                         |

### When Should We Choose Which One?

Terraform is a great tool for managing infrastructure using code. However, it is not the right tool for every situation. Here are some guidelines to help you decide when to use Terraform:

## Choose Terraform when

- You need to manage infrastructure across multiple cloud providers. e.g., (AWS workloads + Cloudflare DNS + GitHub repos + Datadog monitoring).
- You want concise, readable code with rich logic (loops, dynamic blocks, string manipulation).
- You need uniform tooling across all engineering teams.

## Choose CloudFormation when

- You want deep integration with AWS services and use AWS-specific features.
- You need granular control over resource dependencies and stack updates.
- You are 100% all-in on AWS with zero plans to use other cloud platforms.
- You prefer AWS to handle state storage, locking, and rollback natively without configuring S3/DynamoDB backends.

# Workflow

### Normally / Manual Workflow for infrastructure Management

```
Login to AWS
     ↓
Create VPC
     ↓
Create subnet
     ↓
Create security group
     ↓
Create EC2
     ↓
Configure server
```

### With Terraform Workflow

The Terraform workflow is a four-step process that is used to manage infrastructure using Terraform.

1. Initialize : Initialize the Terraform working directory.
2. Plan : Plan the infrastructure changes.
3. Apply : Apply the infrastructure changes.
4. Destroy : Destroy the infrastructure

So infrastructure becomes repeatable and automated.

### Workflow Diagram

```
Terraform Code
     ↓
terraform plan
     ↓
terraform apply
     ↓
AWS Infrastructure
```

```
┌──────────────────────┐
│     Terraform CLI    │
│  terraform plan/apply│
└─────────┬────────────┘
          │
          ▼
┌──────────────────────┐
│   Configuration      │
│  .tf files, vars     │
└─────────┬────────────┘
          │
          ▼
┌──────────────────────┐
│    Provider Layer    │
│  AWS, Azure, GCP...  │
└─────────┬────────────┘
          │
          ▼
┌──────────────────────┐
│  State Management    │
│  terraform.tfstate   │
│  Locking (DynamoDB)  │
└──────────────────────┘
```

# Important Notes

- The same instance type can be run on an on-premises server or in AWS with just a change in variables.
- This versatility is the main reason for the popularity of Terraform.
- In an interview, they will likely ask you to draw the workflow and explain it. Make sure to memorize it.
- It is always better to use a proper VSCode extension for Terraform, like “HashiCorp Terraform” by Mohannad Masoud.

# Why Terraform ?

1. Automation : Automates the process of provisioning and managing infrastructure.
2. Repeatability : Infrastructure can be recreated exactly as defined in the code.
3. Version Control : Infrastructure can be version-controlled and shared among team members.
4. Orchestration/Multi-Cloud: Infrastructure can be managed across multiple cloud providers.Terraform supports many providers, such as:(AWS,Azure,Google Cloud,Kubernetes,Docker,GitHub,Cloudflare)
5. Security : Infrastructure can be secured using Terraform's security features.
6. Cost Management : Infrastructure can be managed to optimize costs.
7. Disaster Recovery : Infrastructure can be recovered in case of disaster.
8. Compliance : Infrastructure can be made compliant with industry standards.
9. Monitoring : Infrastructure can be monitored using Terraform's monitoring features.
10. Scalability : Infrastructure can be scaled up or down as needed.
11. Infrastructure consistency : Infrastructure can be made consistent across multiple environments.
12. Change tracking : Changes are tracked and versioned in Git.

13. Audity and Monitoring : Auditing and monitoring of infrastructure changes can be done using Terraform's auditing and monitoring features.

# Terraform Architecture

Simple architecture is :

              Terraform Configuration
                       │
                       ▼
                ┌─────────────┐
                │  Terraform  │
                │   CLI/Core  │
                └──────┬──────┘
                       │
                       ▼
                  Provider
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
         AWS        Kubernetes     Docker
          │            │            │
          ▼            ▼            ▼
     Infrastructure Infrastructure Infrastructure

### Terraform core

Reads `.tf` files
create execution plan
maintain state file
determines resource dependencies
communicates with providers

### Terraform Provider

Plugins that allow Terraform to communicate with different cloud providers.
A provider allows Terraform to communicate with an external platform

For Example:

(terraform → aws provider → aws console)
(terraform → Kubernetes Provider → Kubernetes Cluster)

In the code below, the provider is aws

```h
provider "aws" {
    region = "us-east-1"
}
```

### Terraform Workflow

Most important concept

```
┌────────────────────────┐
│  Write Terraform Code  │
│       (*.tf files)     │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│  Terraform Init        │
│  Initialize backend/   │
│       plugins          │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│  Terraform Validate    │
│  Syntax & config check │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│  Terraform Plan        │
│  Preview changes       │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│  terraform apply       │
│  Create/update infra   │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│  Infrastructure        │
│  Created/Updated       │
└────────────────────────┘
```

### Terraform destroy

Use when we want to remove the infrastructure

```
┌────────────────────────┐
│  Terraform Destroy     │
│  Destroy infrastructure│
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│  Infrastructure        │
│      Destroyed         │
└────────────────────────┘
```

### Notes:

- Terraform configuration files have a `.tf` extension.
- Terraform uses a state file to keep track of the resources that have been created by Terraform.

```
INIT -> VALIDATE -> PLAN -> APPLY -> DESTROY
```

### Terraform state file

It is a JSON file that keeps track of the resources that have been created by Terraform.

Typically not written by hand, but Terraform automatically creates and manages it. So named `terraform.tfstate`, but can be renamed.

It maps the resources declared in your Terraform configuration files (`.tf`) to the actual, physical resources deployed in your cloud environment.

state is stored in :

1. default (local state) : It is stored in the same directory as the Terraform configuration files. It is not recommended for production use.

2. Remote state : It is stored in a remote location, such as AWS S3, Azure Blob Storage, Google Cloud Storage or HCP Terraform Cloud. It is recommended for production use.

very Important deep concept

```
┌────────────────────────────────────────┐
│            Terraform State             │
│ (Local file or Remote Backend like S3) │
└───────────────────┬────────────────────┘
                    │
                    ▼
┌───────────────────┴──────────────────────┐
│     Track of Infrastructure Reality      │
│Maps Config Resources → Physical Resources│
└───────────────────┬──────────────────────┘
                    │
      ┌─────────────┴─────────────┐
      ▼                           ▼
┌─────────────┐         ┌─────────────┐
│  Read State │         │ Update State│
│  (Plan/Diff)│         │ (Apply/Done)│
└───────┬─────┘         └──────┬──────┘
        │                     │
        ▼                     ▼
┌────────────────────────────────────────┐
│  Compare with Cloud Reality (Drift)    │
│  Detect added/modified/deleted resources │
└───────────────────┬──────────────────────┘
                    │
                    ▼
┌───────────────────┴──────────────────────┐
│    Determine Actions (Add/Update/Remove) │
│          Generate Execution Plan         │
└───────────────────┬──────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────┐
│  Apply Changes → Cloud Infrastructure  │
└────────────────────────────────────────┘
```

Terraform compares these to determine changes needed to match declared state
**Real Cloud Resources <-> State File <-> Terraform Config**

```
Desired State
     │
     ▼
Terraform Configuration
     │
     │ compare
     ▼
Terraform State
     │
     │ compare
     ▼
Actual Infrastructure

```

conceptually:

```
             Terraform
                 │
       ┌─────────┴─────────┐
       ▼                   ▼
Configuration            State
(main.tf)          (terraform.tfstate)
       │                   │
       └─────────┬─────────┘
                 ▼
          Determine changes
                 │
                 ▼
          Actual resources
```

This is why state management becomes extremely important in production.

# Important Terraform Files

```
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
├── versions.tf
└── .terraform.lock.hcl
└─── security.tf
```

### Explainsion of Important Terraform Files

1. main.tf : It is the main configuration file for Terraform. It contains the configuration for the resources that will be created by Terraform.

2. variables.tf : It is the file that contains the variables for the Terraform configuration.

3. outputs.tf : It is the file that contains the outputs for the Terraform configuration.

4. providers.tf : It is the file that contains the providers for the Terraform configuration.

5. terraform.tfvars : It is the file that contains the values for the variables in the Terraform configuration.

6. versions.tf : It is the file that contains the versions for the Terraform configuration.

7. .terraform.lock.hcl : It is the file that contains the lock for the Terraform configuration.

8. security.tf : It is the file that contains the security for the Terraform configuration.

### Terraform Commands

1. terraform init :
   - It is the command that is used to initialize the Terraform configuration.
   - It downloads the provider plugins and modules required for the configuration.
   - It is the first command that is run in a new Terraform configuration.

   ```
   terraform init
   ```

2. terraform validate :
   - It is the command that is used to validate the Terraform configuration.
   - It checks the syntax and configuration of the Terraform files.
   - It is the second command that is run in a new Terraform configuration.

   - Example of command

   ```
   terraform validate
   ```

3. terraform plan :
   - It is the command that is used to plan the Terraform configuration.
   - It shows the changes that will be made to the infrastructure.
   - It is the third command that is run in a new Terraform configuration.

   - Example of command

   ```
   terraform plan
   ```

4. terraform apply :
   - It is the command that is used to apply the Terraform configuration.
   - It creates or updates the infrastructure.
   - It is the fourth command that is run in a new Terraform configuration.

   - Example of command

   ```
   terraform apply
   ```

Use the -auto-approve flag to automatically approve the changes without human intervention

```
terraform apply -auto-approve
```

5.  terraform destroy :
    - It is the command that is used to destroy the Terraform configuration.
    - It removes the infrastructure.
    - It is the fifth command that is run in a new Terraform configuration.

    - Example of command

    ```
    terraform destroy
    ```

    #### Extra commands
    6. terraform fmt :
       - It is the command that is used to format the Terraform configuration.
       - It formats the Terraform files to follow the standard Terraform formatting guidelines.
       - It is the sixth command that is run in a new Terraform configuration.

       - Example of command

       ```
       terraform fmt
       ```

    7. terraform workspace :
       - It is the command that is used to manage the Terraform workspace.
       - It manages the workspace for the Terraform configuration.
       - It is the seventh command that is run in a new Terraform configuration.

       - Example of command

       ```
       terraform workspace
       ```

    8. terraform state :
       - It is the command that is used to manage the Terraform state.
       - It manages the state for the Terraform configuration.
       - It is the eighth command that is run in a new Terraform configuration.

       - Example of command

       ```
       terraform state
       ```

    9. terraform output :
       - It is the command that is used to output the Terraform configuration.
       - It outputs the values for the outputs in the Terraform configuration.
       - It is the ninth command that is run in a new Terraform configuration.

       - Example of command

       ```
       terraform output
       ```

    10. terraform graph :
        - It is the command that is used to generate the graph for the Terraform configuration.
        - It generates the graph for the Terraform configuration.
        - It is the tenth command that is run in a new Terraform configuration.

        - Example of command

        ```
        terraform graph
        ```

    11. terraform version :
        - It is the command that is used to show the Terraform version.
        - It shows the version of Terraform.
        - It is the eleventh command that is run in a new Terraform configuration.

        - Example of command

        ```
        terraform version
        ```

    12. terraform show
        - It is the command that is used to show the Terraform configuration.
        - It shows the configuration of the Terraform.
        - It is the twelfth command that is run in a new Terraform configuration.

        - Example of command

        ```
        terraform show
        ```

    13. terraform providers
        - It is the command that is used to show the Terraform providers.
        - It shows the providers of the Terraform.
        - It is the thirteenth command that is run in a new Terraform configuration.

        - Example of command

        ```
        terraform providers
        ```

# First Terraform configuration example

```hcl
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "local" {}

resource "local_file" "example" {
    filename = "hello.txt"
    content  = "Hello from Terraform!"
}


```

### command to run the above configuration

1.

```
terraform init
```

2.

```
terraform validate
```

3.

```
terraform plan
```

4.

```
terraform apply
```

5.

```
terraform destroy
```

## Important Note

- Terraform configuration files have a `.tf` extension.
- Terraform uses a state file to keep track of the resources that have been created by Terraform.
- Terraform is a declarative configuration management tool.
- Terraform is used to create, update, and destroy infrastructure.
- Terraform is used to manage the state of the infrastructure.
# Terraform-project-docs
