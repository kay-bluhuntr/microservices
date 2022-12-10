output "aurora_instance_parameter_group_name" {
  description = "The parameter group"
  value       = aws_db_parameter_group.aurora_instance_parameter_group.name
}
