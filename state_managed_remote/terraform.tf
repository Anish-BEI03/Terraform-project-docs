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
    
}


}