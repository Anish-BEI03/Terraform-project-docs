# Count meta-argument Example:
/*
resource "local_file" "example" {
  count = 3

  filename = "file-${count.index}.txt"
  content  = <<-EOF
  "Terraform file" ${count.i}

EOF
}
*/

# for_each Example:

resource "local_file" "servers" {
  #for_each = toset(["a", "b", "c"])

  for_each = tomap(var.servers)


  filename = "${each.key}.txt"
  # content  = "server:${each.value}"  or
  content = <<-EOF
    server_value:${each.value}
    server_type: ${each.key}
    
    
  EOF
}

locals {
  #for loop syntax
  #[for item in collection : expression]
  upper_name = [
    for name in var.names :upper(name)
  ]
}

output "demo" {
  value = [
    for key,val in local_file.servers :
    "${val.filename} -> ${val.content}"
  ]
}

output "upper_names" {
  value = local.upper_name
}

/*
output "demo2" {
  value = local_file.servers[*].filename
}
*/