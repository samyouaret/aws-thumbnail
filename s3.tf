resource "aws_s3_bucket" "s3_bucket" {
  bucket = "samyouaret_thumbnail_pictures"
  tags = {
    "project" = "thumbnail-gen"
  }
}
