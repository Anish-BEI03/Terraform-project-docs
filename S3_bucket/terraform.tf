terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}

# HCL code of AWS S3 Bucket
/*

resource "aws_s3_bucket" "my_bucket"{
    bucket = "my-s3-bucket-005"
    tags = {
        Name = "my-s3-bucket"
        Environment = "Dev"
    }
}
*/