# Run the Project

1. initialize the project
   ```bash
   terraform init
   ```
2. format the project
   ```bash
   terraform fmt
   ```
3. terraform validate
   ```bash
   terraform validate
   ```
4. terraform plan
   ```bash
   terraform plan
   ```
5. terraform apply

   ```bash
   terraform apply
   ```

6. terraform output

   ```bash
   terraform output
   ```

7. destroy the project
   ```bash
   terraform destroy
   ```

# imaging picture:

```
                  Variables
                      │
                      ▼
              ┌──────────────┐
              │   Terraform  │
              └──────┬───────┘
                     │
              ┌──────▼──────┐
              │    Locals   │
              └──────┬──────┘
                     │
                     ▼
                  Resources
                     │
                     ▼
                   Outputs

```

# Important Note:

```
1. In HCL (HashiCorp Configuration Language),
   variable access inside terraform code
${var.variable_name}

2. or

var.variable_name

3. means :- ${ } is nothing but expression in hcl language

4. var --> keyword
   ↓
variable --> block name
   ↓
filename --> attribute name
```

## Importance syntax to remember:

#### Input variable syntax

```bash
${var.variable_name}

var.variable_name
```

#### Output variable syntax

```bash
output "name"
```

### resourse syntax

```bash
resourse_type.resourse_name
```

### local syntax

```bash
local.local_name
```
