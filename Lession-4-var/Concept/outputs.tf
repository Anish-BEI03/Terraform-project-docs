output "filename" {
  description = "Created file"
  value       = local_file.devops.filename
}


output "content" {
  description = "Content of the file"
  value       = local_file.devops.content
}

output "password" {
  value     = var.password
  sensitive = true
}
