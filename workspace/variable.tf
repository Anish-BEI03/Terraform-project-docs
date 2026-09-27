# AMI ID for Ubuntu in eu-west-1
variable "AMI_ID" {
    type = string
    default = "ami-0b6d9d3d33ba97d99"
}

# instance type to create ec2 instance
variable "INSTANCE_TYPE" {
    type = string
    default = "t3.micro"
}

# volume size for ec2 instance root block device
variable "volume_size" {
    type = number
    default = 8
}

# volume type for ec2 instance root block device
variable "volume_type" {
  type = string
  default = "gp3"
}

# delete on termination for ec2 instance root block device
variable "delete_on_termination" {
  type = bool
  default = true
}

# key name for ec2 instance ssh connection
variable "key_name" {
    type = string
    default = "terra-key"
}

# security group name for ssh connection and http connection
variable "ssh-sg" {
  type = map(string)
  default = {
    Name = "ssh-sg"
  }
}



# Environment for tags for workspace
variable "environment" {
  type = string
  description = "The name of the environment"
}