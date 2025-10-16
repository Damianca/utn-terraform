output "db_name" {
  value = aws_db_instance.rds_postgre_sql.identifier
}

output "db_endpoint" {
  value = aws_db_instance.rds_postgre_sql.endpoint
}