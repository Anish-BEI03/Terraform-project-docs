# key pair name
variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default     = "terra-key-ec2"
}

variable "ami_id" {
  description = "The ID of the AMI"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "volume_default_size" {
  description = "The size of the volume"
  type        = number
  default     = 8
}

variable "env" {
  description = "The environment"
  type        = string
  default     = "prod"
}

variable "instance_type" {
  description = "The type of the instance"
  type        = string
  default     = "t2.micro"
}


variable "instance_names" {
  type    = set(string)
  default = ["web-server1", "web-server2", "web-server3"]
}

variable "tags" {
  type    = map(string)
  default = { Name = "Web-Server" }
}

variable "tags-sg" {
  description = "Tags for the security group"
  type        = map(string)
  default = {
    Name = "Web-Server-sg"
  }
}



