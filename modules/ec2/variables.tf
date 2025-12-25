
variable "vpc_id" {
  description = "VPC ID where EC2 will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for EC2 instances"
  type        = list(string)
}


variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ec2_root_storage_size" {
  description = "Root storage size in GB"
  type        = number
  default     = 30
}

variable "ec2_root_storage_type" {
  description = "Root storage type"
  type        = string
  default     = "gp3"
}

variable "ec2_ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-042e8287309f5df03" # Ubuntu 20.04 in us-east-1
}
