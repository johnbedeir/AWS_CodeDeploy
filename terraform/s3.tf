resource "aws_s3_bucket" "codedeploy_bucket" {
  bucket = "${var.aws_s3_bucket}-${random_string.suffix.result}"

  tags = {
    Name        = "CodeDeployBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "codedeploy_bucket_versioning" {
  bucket = aws_s3_bucket.codedeploy_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}