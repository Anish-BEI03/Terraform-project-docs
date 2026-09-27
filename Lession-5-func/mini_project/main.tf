terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 6.0"
    }
  }
}

provider "local" {}

resource "local_file" "server" {
  for_each = var.servers

  filename = "${each.key}.txt"

  content = <<-EOT
    Server: ${each.key}
    Managed by Terraform
  EOT
}