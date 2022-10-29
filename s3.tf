resource "aws_s3_bucket" "s3_bucket" {
  bucket = "samyouaret-thumbnail-pictures"
  tags = {
    "project" = "thumbnail-gen"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}