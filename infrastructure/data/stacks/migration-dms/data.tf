# Source DB lookup
data "aws_db_instance" "source_database" {
  db_instance_identifier = var.db_source_instance
}

# Target DB lookup Aurora cluster endpoint
data "aws_rds_cluster" "target_database" {
  cluster_identifier = "${var.cluster_id}-${local.aurora_engine_major_version}"
}

# Target DB lookup
data "aws_db_instance" "fallback_database" {
  db_instance_identifier = var.db_fallback_instance
}

