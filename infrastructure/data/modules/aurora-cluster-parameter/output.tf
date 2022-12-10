output "aurora_cluster_parameter_group_name" {
  description = "The parameter group"
  value       = aws_rds_cluster_parameter_group.cluster_parameter_group.name
}