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

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.cbz_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.this.website_endpoint
}




/*
--------------------------------------------------
cloudfront + s3 bucket 
--------------------------------------------------


# --------------------------------------------------
# Create PRIVATE S3 bucket (no public access)
# --------------------------------------------------
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name = "flight-reservation-frontend"
    env  = var.environment
  }
}

# --------------------------------------------------
# Ownership controls (REQUIRED for AWS provider v5)
# --------------------------------------------------
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# --------------------------------------------------
# Block ALL public access to S3 bucket
# Website access will be ONLY via CloudFront
# --------------------------------------------------
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --------------------------------------------------
# CloudFront Origin Access Control (OAC)
# This allows CloudFront to securely access private S3
# --------------------------------------------------
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "flight-reservation-oac"
  description                       = "OAC for private S3 access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# --------------------------------------------------
# CloudFront Distribution (HTTPS enabled by default)
# --------------------------------------------------
resource "aws_cloudfront_distribution" "this" {

  # S3 origin (private bucket)
  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.this.id
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  enabled             = true
  default_root_object = var.index_document

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.this.id

    # Force HTTPS
    viewer_protocol_policy = "redirect-to-https"

    # No query strings or cookies needed for static frontend
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # No geo restriction
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Use default CloudFront HTTPS certificate (*.cloudfront.net)
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = var.price_class

  tags = {
    env = var.environment
  }
}

# --------------------------------------------------
# S3 Bucket Policy
# Allow ONLY CloudFront to read objects
# --------------------------------------------------
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.this.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.this.arn
        }
      }
    }]
  })

  depends_on = [
    aws_cloudfront_distribution.this,
    aws_s3_bucket_public_access_block.this
  ]
}

# --------------------------------------------------
# Summary:
# - S3 bucket is PRIVATE
# - No public access allowed
# - CloudFront accesses S3 using OAC
# - HTTPS enforced using CloudFront default cert
# --------------------------------------------------

*/
