output "file_name" {
  description = "Generated file name"
  value       = local_file.project.filename
}

output "environment" {
  description = "Current environment"
  value       = var.environment
}