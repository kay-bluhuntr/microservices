variable "aurora_family" {
  description = "Database family - eg postgres12"
  default = "aurora-postgresql14"
}

variable "aurora_cluster_parameter_group_name" {
  description = "Parameter group name for the Cluster"
  default = "aurora-cluster-parameter-group"
}

variable "description" {
  description="Description of cluster parameter group purpose"
}

variable "db_max_connections" { default = 50 }

# To avoid a reboot when changing this static parameter decided to leave it 'on'
# to support any future migration
variable "rds_logical_replication" {
  description = "Toggle for logical replication"
  default = "1"
}
# Parameter relevant to any future migration so left 'on'
# has no impact outside of replication/migration
variable "wal_sender_timeout" {
  description = "Timeout for wal sender"
  default = "0"
}

variable "log_lock_waits" {
  description = "Logs long lock waits"
  default = "0"
}

variable "log_min_duration_statement" {
  description = "Log any sql statement that runs over value"
  default = "-1"
}

variable "shared_preload_libraries" {
  description = "Lists shared libraries to preload into server"
  default = "pg_stat_statements,pg_hint_plan"
}

variable "default_statistics_target" {
  description = "The amount of information stored in pg_statistic by ANALYZE"
  default = "256"
}

variable "random_page_cost" {
  description = "Sets the planners estimate of the cost of a nonsequentially fetched disk page"
  default = 1
}

variable "apg_enable_remove_redundant_inner_joins" {
  description = "Enables the planner to remove redundant inner joins"
  default = 1
}

#variable "context" { description = "A set of predefined variables coming from the Make DevOps automation scripts and shared by the means of the context.tf file in each individual stack" }
