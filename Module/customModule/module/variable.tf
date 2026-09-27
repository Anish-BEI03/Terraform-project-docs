variable "Env" {
  type        = string
  description = "Environment name for my infra"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}


variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to create"
}

variable "ami-id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
}

variable "key_value" {
  type        = string
  description = "path of Public key for the EC2 instance"
} 