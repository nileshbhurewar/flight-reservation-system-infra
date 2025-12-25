# Make sure you already ran: ssh-keygen -t rsa -b 2048 -f terra-key-ec2
# or only ssh-keygen
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("${path.module}/terra-key-ec2.pub")
}

# path.module = absolute path of the current module directory
