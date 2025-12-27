# Security Group for RDS (Custom VPC)
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # allow only VPC traffic
    description = "MySQL access from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# DB Subnet Group (PRIVATE subnets)
resource "aws_db_subnet_group" "this" {
  name       = "cbz-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "cbz-db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "cbz_db_instance" {
  identifier              = "cbz-db"
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class

  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.this.name

  publicly_accessible     = false   # 🔥 important
  skip_final_snapshot     = true

  tags = {
    Name = "cbz-db-instance"
  }
}
