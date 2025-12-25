# Create an S3 bucket for frontend static website
resource "aws_s3_bucket" "cbz_bucket" {
  bucket = "cbz-frontend-project-bux3322" # must be globally unique

  tags = {
    Name = "StaticWebsiteBucket"
    env  = "dev"
  }
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "cbz_website" {
  bucket = aws_s3_bucket.cbz_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Disable block public access (required for public website)
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.cbz_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Allow public read access to objects
resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.cbz_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.cbz_bucket.arn}/*"
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.example
  ]
}

# Output the website endpoint
output "website_endpoint" {
  value       = aws_s3_bucket.cbz_bucket.website_endpoint
  description = "Public S3 static website URL"
}
