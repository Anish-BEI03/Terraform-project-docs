
resource "aws_s3_bucket" "infra-s3" {
  bucket = "${var.Env}-${var.bucket_name}"

  tags = {
    Name        = "${var.Env}-${var.bucket_name}"
    Environment = var.Env
  }
}
