# -----------------------------
# S3 Bucket
# -----------------------------
resource "aws_s3_bucket" "cbz_bucket" {
  bucket = "cbz-frontend-project-bux3322"

  tags = {
    Name = "StaticWebsiteBucket"
    env  = "dev"
  }
}

# -----------------------------
# Disable Block Public Access (bucket level)
# -----------------------------
resource "aws_s3_bucket_public_access_block" "cbz_public_access" {
  bucket = aws_s3_bucket.cbz_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# -----------------------------
# Website configuration (ONLY ONE)
# -----------------------------
resource "aws_s3_bucket_website_configuration" "cbz_website" {
  bucket = aws_s3_bucket.cbz_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# -----------------------------
# Public read bucket policy
# -----------------------------
resource "aws_s3_bucket_policy" "cbz_policy" {
  bucket = aws_s3_bucket.cbz_bucket.id

  depends_on = [
    aws_s3_bucket_public_access_block.cbz_public_access
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.cbz_bucket.arn}/*"
    }]
  })
}

# -----------------------------
# Output
# -----------------------------
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.cbz_website.website_endpoint
}
