terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random ={
        source = "hashicorp/random"
        version = "3.6.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# random id generation for bucket name
resource "random_id" "bucket-suffix" {
  byte_length = 8
}

# bucket creation 
resource "aws_s3_bucket" "anish-bucket" {
  bucket = "anish-bucket-portfolio-${random_id.bucket-suffix.hex}"
  tags = {
    Name        = "anish-bucket-portfolio-${random_id.bucket-suffix.hex}"
    Environment = "production"
  }
}

# block public access settings
resource "aws_s3_bucket_public_access_block" "anish-bucket" {
  bucket = aws_s3_bucket.anish-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# upload index.html file to the bucket
resource "aws_s3_object" "index-html" {
  bucket       = aws_s3_bucket.anish-bucket.id
  key          = "index.html"
  source       = "./index.html"
  etag         = filemd5("./index.html")
  content_type = "text/html"
}

# upload assert folder files (images) to the bucket
resource "aws_s3_object" "assert_files" {
  for_each     = fileset("${path.module}/assert", "*")
  bucket       = aws_s3_bucket.anish-bucket.id
  key          = "assert/${each.value}"
  source       = "${path.module}/assert/${each.value}"
  etag         = filemd5("${path.module}/assert/${each.value}")
  content_type = "image/png"
}

# policy to allow public read access to objects
resource "aws_s3_bucket_policy" "anish-bucket" {
  bucket = aws_s3_bucket.anish-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Principal = "*"
        Resource = "arn:aws:s3:::${aws_s3_bucket.anish-bucket.id}/*"
      }
    ]
  })
}

# webiste configuration 
resource "aws_s3_bucket_website_configuration" "anish-bucket" {
  bucket = aws_s3_bucket.anish-bucket.id
  index_document {
    suffix = "index.html"
  }

}


# output the website URL
output "website_url" {
  value = aws_s3_bucket_website_configuration.anish-bucket.website_endpoint
}
