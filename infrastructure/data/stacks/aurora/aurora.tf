module "aurora-cluster-pg" {
  source  = "../../modules/aurora-cluster-parameter"

  aurora_cluster_parameter_group_name = "${var.aurora_cluster_parameter_group_name}-${local.aurora_engine_major_version}"
  description                         = "Cluster parameter group for ${local.aurora_engine_major_version}"
  aurora_family                       = var.aurora_family
  db_max_connections                  = var.db_max_connections
}

module "aurora-instance-pg" {
  source  = "../../modules/aurora-instance-parameter"

  aurora_instance_parameter_group_name = "${var.aurora_instance_parameter_group_name}-${local.aurora_engine_major_version}"
  description                          = "Instance parameter group for ${local.aurora_engine_major_version}"
  aurora_family                        = var.aurora_family
  db_max_connections                   = var.db_max_connections
}

module "cluster" {
  source = "terraform-aws-modules/rds-aurora/aws"
    version = "6.2.0"

  name           = "${var.cluster_id}-${local.aurora_engine_major_version}"
  engine         = var.aurora_engine
  engine_version = var.aurora_engine_version
  instance_class = var.aurora_cluster_instance_class
  instances = {
    one = { },
    two = { }
  }
  preferred_backup_window      = var.backup_window
  preferred_maintenance_window = var.preferred_cluster_maintenance_window
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  
  # Reader Autoscaling
  autoscaling_enabled      = var.aurora_cluster_auto_scaling_enabled
  autoscaling_min_capacity = var.minimum_reader_capacity
  autoscaling_max_capacity = var.maximum_reader_capacity

  vpc_id  = "vpc-03e09d615d8941622"
  subnets = ["subnet-03cc6d9e60484b6b3", "subnet-074f384a23b6d5d8b"]

  create_security_group  = true

  deletion_protection = var.deletion_protection
  master_username     = var.cluster_master_username
  master_password                  = var.db_master_password
  create_random_password           = false
  storage_encrypted                = true
  apply_immediately                = true
  monitoring_interval              = 10
  copy_tags_to_snapshot            = var.copy_tags_to_snapshot
  skip_final_snapshot              = true
  iam_role_name                    = "aurora-monitoring"
  iam_role_use_name_prefix         = true
  final_snapshot_identifier_prefix = "${var.cluster_id}-${local.aurora_engine_major_version}-final-snapshot"

  db_cluster_parameter_group_name  = module.aurora-cluster-pg.aurora_cluster_parameter_group_name
  db_parameter_group_name          = module.aurora-instance-pg.aurora_instance_parameter_group_name

  create_db_subnet_group           = true
  performance_insights_enabled     = var.performance_insights_enabled
  enabled_cloudwatch_logs_exports  = ["postgresql"]
}
