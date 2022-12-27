output "host_address" {
  value = aws_db_instance.jump.address
}

output "name" {
  value = aws_db_instance.jump.db_name
}
