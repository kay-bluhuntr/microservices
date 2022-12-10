variable "terraform_platform_state_store" {
  description = "Name of the S3 bucket used to store the Terraform state"
}

variable "vpc_terraform_state_key" {
  description = "The VPC terraform state key"
}

# variable "dms_terraform_state_key" {
#   description = "The DMS terraform state key"
# }

variable "replication_instance_id" {
  description = "The DMS Replication Instance Id"
}

# DMS Endpoint variables

variable "texas_aws_certificate_arn" {
  description = "The ARN of the AWS certificate"
}

variable "db_source_instance" {
  description = "The instance identifier of the source database"
}

variable "source_database_name" {
  description = "The name of the source database"
}

# variable "source_db_username" {
#   description = "The username used to connect to the source database"
# }

variable "db_master_password" {
  description = "The password for the user used to connect to the source database"
}

# variable "db_target_instance" {
#   description = "The instance identifier of the target database"
# }

variable "db_fallback_instance" {
  description = "The instance identifier of the database used if we need to rollback db version with no data loss"
}

# variable "target_db_host_name" {
#   description = "The host name of the target database"
# }

variable "target_database_name" {
  description = "The name of the target database"
}

variable "fallback_database_name" {
  description = "The name of the target database"
}

# DMS task variables

variable "dms_forward_migration_type" {
  description = "The migration type for the DMS task"
  default     = "full-load-and-cdc"
}

variable "dms_fallback_migration_type" {
  description = "The migration type ONLY replicating back to original source"
  default     = "full-load-and-cdc"
}

variable "cluster_id" { description = "The unique id of the aurora cluster" }
variable "aurora_engine_version" {
  description = "Version of aurora engine"
}
