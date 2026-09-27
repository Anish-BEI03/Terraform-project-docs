
resource "random_bytes" "suffix_bucket" {
  length = 8
}

resource "aws_s3_bucket" "remote_bucket" {
  bucket = "terraform-state-bucket-${random_bytes.suffix_bucket.hex}"

  tags = {
    Name = "terrafrom-statefile-bucket-${random_bytes.suffix_bucket.hex}"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.remote_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
