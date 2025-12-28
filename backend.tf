terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "cbz-terraform-state-prod"
    key            = "flight-reservation/infra/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

/*
One-time AWS setup (if not done already)

If these already exist, skip this section.

1️⃣ S3 bucket for state
aws s3api create-bucket \
  --bucket cbz-terraform-state-prod \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1


Enable versioning:

aws s3api put-bucket-versioning \
  --bucket cbz-terraform-state-prod \
  --versioning-configuration Status=Enabled

2️⃣ DynamoDB table for locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1

🔄 How to migrate existing state (CRITICAL STEP)

Run this from the same directory where your Terraform code exists:

terraform init
*/
