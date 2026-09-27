terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
/*
  backend "s3"{
    bucket         = "terraform-state-bucket-1"
    key            ="terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-table-1"
    
    
  }*/
}