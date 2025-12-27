provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "rds" {
  source = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "eks" {
  source = "./modules/eks"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "s3" {
  source = "./modules/s3"
}

# aws configure  then , 
# terraform init
#terraform validate
#terraform plan
#terraform apply

# Test Ansible (IMP) AFter Infra Created  ON Ubuntu 
# cd ansible
#ansible all -m ping
#ansible-playbook playbooks/jenkins.yml
#ansible-playbook playbooks/sonarqube.yml