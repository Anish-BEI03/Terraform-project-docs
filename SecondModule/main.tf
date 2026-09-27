resource "local_file" "My_file" {
  filename = "test.txt"
  content  = <<-EOF
This is a test file created by terraform.
It contains multiple lines of text.
Terraform is a Infrastructure as Code tool.
EOF
}

resource "local_file" "devops" {
  filename = "devops.txt"

  content = <<-EOT
    Terraform
    Docker
    Kubernetes
    Jenkins
    Ansible
  EOT


}

# Implicit dependencies - terraform automatically creates dependencies between resources
# based on resource references.
# Example:- if resource A references resource B, terraform 
# automatically creates a dependency between resource A and resource B.
# In this case, terraform automatically creates a dependency between My_file and devops.

resource "local_file" "first" {
  filename = "first.txt"
  content  = "First file"
}

resource "local_file" "second" {
  filename = "second.txt"
  content  = local_file.first.content
}



# Explicit dependencies - terraform automatically creates dependencies between resources
# based on resource references.
# Example:- if resource A references resource B, terraform 
# automatically creates a dependency between resource A and resource B.
# In this case, terraform automatically creates a dependency between My_file and devops.
# Use to define explicit dependencies between resources
# Example:- terraform uses the `depends_on` meta-argument to define explicit dependencies between resources.

resource "local_file" "third" {
  filename = "third.txt"
  content  = "Third file"

  # Explicit dependencies define order in which resources are created.
  # Use it when Terraform cannot detect dependencies automatically.
  depends_on = [
    local_file.second // run second file before third file

  ]

}


