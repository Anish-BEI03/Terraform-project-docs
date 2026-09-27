# instance type
variable "instance_type" {
  description = "Type of the EC2 instance to create"
  type        = string
  default     = "t3.micro"
}

# image id for ubuntu in eu-west-1 region
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0b6d9d3d33ba97d99"
}

# ssh key name
variable "key_name" {
  description = "Name of the SSH key pair to use for the EC2 instance"
  type        = string
  default     = "terra-key-ec2"
}

# volume size
variable "volume_size" {
  description = "Size of the EBS volume in GiB"
  type        = number
  default     = 8
}

variable "tags_sg" {
  description = "Tag to apply to the security group"
  type        = map(string)
  default = {
    Name = "my_sec_group"
  }
}

# tags to apply to the EC2 instance
variable "instance_names" {
  description = "Tags for the multiple instance"
  type        = set(string)
  default     = ["web-server1", "web-server2", "web-server3"]
}

