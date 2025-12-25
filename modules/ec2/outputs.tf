output "ec2_jenkins_public_ip" {
  value = aws_instance.my_instance["jenkins"].public_ip
}

output "ec2_sonarqube_public_ip" {
  value = aws_instance.my_instance["sonarqube"].public_ip
}

output "ec2_jenkins_private_ip" {
  value = aws_instance.my_instance["jenkins"].private_ip
}

output "ec2_sonarqube_private_ip" {
  value = aws_instance.my_instance["sonarqube"].private_ip
}
