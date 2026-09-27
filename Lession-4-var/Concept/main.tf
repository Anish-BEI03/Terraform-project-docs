resource "local_file" "devops" {
  filename = var.filename
  content  = <<-EOT
    Environment: ${var.environment}
    env : ${var.env}
    password: ${var.password}
    app_name : ${local.app_name}
  EOT
}
