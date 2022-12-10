variable "aurora_instance_parameter_group_name" {
  description = "Name of parameter group for aurora instances"
  default = "aurora-instance-parameter-group"
}

variable "description" {
  description="Description of cluster parameter group purpose"
}

variable "db_max_connections" {
  default = 10
}

variable "aurora_family" {
  description = "Database family - eg postgres12"
  default = "aurora-postgresql14"
}

# variable "context" { description = "A set of predefined variables coming from the Make DevOps automation scripts and shared by the means of the context.tf file in each individual stack" }
