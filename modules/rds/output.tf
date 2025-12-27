output "rds_endpoint" {
  value = aws_db_instance.cbz_db_instance.endpoint
}

output "rds_port" {
  value = aws_db_instance.cbz_db_instance.port
}
