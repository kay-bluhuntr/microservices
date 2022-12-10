variable "aurora_instance_parameter_group_name" {
  description = "Name of parameter group for aurora instances"
  default = "aurora-instance-parameter-group"
}

variable "description" {
  description="Description of cluster parameter group purpose"
}

variable "db_max_connections" {
  default = 30
}

variable "aurora_family" {
  description = "Database family - eg aurora-postgres14"
  default = "aurora-postgresql14"
}
