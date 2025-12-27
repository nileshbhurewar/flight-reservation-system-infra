
/*
----------------------------------------
for s3 + cloudfront 
----------------------------------------


# S3 bucket name (must be globally unique)
variable "bucket_name" {
  type    = string
  default = "flight-reservation-frontend-project-bux"
}

# Environment tag
variable "environment" {
  type    = string
  default = "dev"
}

# Default index document for frontend
variable "index_document" {
  type    = string
  default = "index.html"
}

# Error document (used by CloudFront default root)
variable "error_document" {
  type    = string
  default = "error.html"
}

# CloudFront price class (limits edge locations to reduce cost)
variable "price_class" {
  type    = string
  default = "PriceClass_100"
}
*/