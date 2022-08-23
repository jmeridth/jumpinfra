resource "aws_s3_bucket" "main" {
  bucket = "${var.name}-assets-${var.environment}"

  tags = {
    Name = var.name
  }
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = var.acl
}
