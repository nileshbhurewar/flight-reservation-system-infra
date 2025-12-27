variable "project" {
  description = "Project name used for EKS resources"
  type        = string
  default     = "flight-reservation-system"
}

variable "desired_nodes" {
  type    = number
  default = 2
}

variable "max_nodes" {
  type    = number
  default = 2
}

variable "min_nodes" {
  type    = number
  default = 2
}

variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "vpc_id" {
  description = "Custom VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS"
  type        = list(string)
}
