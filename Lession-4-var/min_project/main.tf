terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "local" {}

locals {
  filename = "${var.project}-${var.environment}.txt"
}

resource "local_file" "project" {
  filename = local.filename

  content = <<-EOT
    Project: ${var.project}
    Environment: ${var.environment}
    Managed by Terraform
  EOT
}