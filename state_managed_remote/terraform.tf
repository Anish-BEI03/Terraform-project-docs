terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  
  backend "s3" {
    bucket = "terraform-state-bucket-7a7cc75793cd04a7"
    key    = "terraform.tfstate"
    region = "us-east-1"
    //enable_lockfile = true //default value true
    //dynamodb_table = "terraform-state-table-1" //locking
    use_lockfile = true //
    
}


}

/*
For modern Terraform with the S3 backend, state locking can be configured using S3's native lockfile mechanism

This is simpler and more reliable than using DynamoDB for locking.

use_lockfile = true - Enables state locking using S3's native lockfile mechanism


The older DynamoDB-based locking approach is now considered 
legacy/deprecated in current Terraform documentation, so for new projects 
we should learn the S3 lockfile approach first.

*/