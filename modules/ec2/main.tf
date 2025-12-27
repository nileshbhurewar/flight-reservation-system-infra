
resource "aws_instance" "my_instance" {
  for_each = {
    jenkins    = "jenkins-server"
    sonarqube = "sonarqube-server"
  }

  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.my_key.key_name

  subnet_id              = var.public_subnet_ids[0]   #  custom subnet
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = var.ec2_root_storage_type
  }

  tags = {
    Name = each.value
  }
}

