# ###### RDS related ############
# # ==============================================================================
# # Mandatory variables

variable "cluster_id" { 
  description = "The unique id of the aurora cluster" 
}

variable "aurora_cluster_parameter_group_name"{
  description = "Name of parameter group to be created for use with this aurora cluster"
}

variable "aurora_instance_parameter_group_name"{
  description = "Name of parameter group to be created for use with this aurora instance"
}

variable "aurora_family" {
  description = "Database family - eg postgres12"
  default = "aurora-postgresql14"
}

variable "aurora_engine" {
  description = "Aurora Cluster engine eg aurora-postgresql"
  default = "aurora-postgresql"
}
variable "aurora_engine_version" {
  description = "Version of aurora engine"
  default = 14.5
}

variable "db_master_password" {
  description = "master password for cluster"
}

variable "cluster_master_username" {
  description = "username for master user on cluster"
}

variable "auto_minor_version_upgrade" {
  description = "True for aurora cluster to automate minor version upgrades; else false"
  default = false
}

variable "aurora_cluster_instance_class" {
  description = "Type and class idenitfier for aurora cluster"
  default = "db.t4g.large"
}

 variable "aurora_instance_class" {
  description = "Type and class identifier for aurora instance"
  default = "db.t4g.large"
 }


variable "aurora_cluster_auto_scaling_enabled" {
  description = "Enables/Disable auto-scaling of read-replicas in aurora cluster"
  default = true
}
variable "min_reader_capacity" {
  description = "The minimum number of read replicas in cluster"
  default = 1
}

variable "max_reader_capacity" {
  description = "Auto-scaling will not exceed the maximum number of read replicas in cluster"
  default = 2
}

variable "terraform_platform_state_store" {
  description = "Name of the S3 bucket used to store the platform infrastructure terraform state"
  default = "compare-terraform"
}

variable "backup_window" {
  description = "Time window to perform backup of aurora cluster"
  default     = "03:00-05:00"
}

variable "preferred_cluster_maintenance_window" {
  description = "Time window to maintenance on Aurora Cluster"
  default     = "Sun:04:00-Wed:06:00"
}

variable "copy_tags_to_snapshot" {
  description = "Copy all cluster tags to snapshot"
  default     = true
}

variable "deletion_protection" {
  description = "Prevent accidental deletion"
  default = false
}

variable "performance_insights_enabled" {
  description = "Enable/Disable performance insights on cluster"
  default = true
}

variable "db_max_connections" { default = 50 }

