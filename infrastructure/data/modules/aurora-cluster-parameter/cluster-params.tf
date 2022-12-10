resource "aws_rds_cluster_parameter_group" "cluster_parameter_group" {
  name        = var.aurora_cluster_parameter_group_name
  family      = var.aurora_family
  description = var.description

  parameter {
    name         = "max_connections"
    value        = var.db_max_connections
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }


  parameter {
    name         = "timezone"
    value        = "GB"
  }

  parameter {
    name         = "rds.logical_replication"
    value        = var.rds_logical_replication
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "wal_sender_timeout"
    value = var.wal_sender_timeout
  }

  parameter {
    name  = "log_lock_waits"
    value = var.log_lock_waits
  }

  parameter {
    name  = "log_min_duration_statement"
    value = var.log_min_duration_statement
  }

  parameter {
    name  = "shared_preload_libraries"
    value = var.shared_preload_libraries
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "default_statistics_target"
    value = var.default_statistics_target
  }

  parameter {
    name = "random_page_cost"
    value = var.random_page_cost
  }

  parameter {
    name = "apg_enable_remove_redundant_inner_joins"
    value = var.apg_enable_remove_redundant_inner_joins
  }

}
