# Create a new replication instance
resource "aws_dms_replication_instance" "dms_instance" {
  #context = local.context

  allocated_storage           = 50
  apply_immediately           = true
  auto_minor_version_upgrade  = false
  engine_version              = "3.4.6"
  multi_az                    = true
  publicly_accessible         = false
  replication_instance_class  = "dms.r5.xlarge"
  replication_instance_id     = var.replication_instance_id
  replication_subnet_group_id = aws_dms_replication_subnet_group.dms_subnet_group.replication_subnet_group_id

  vpc_security_group_ids = [
    aws_security_group.dms_replication_instance_security_group.id
  ]

  tags = local.context.tags

}

# Create a new replication subnet group
resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_description = "DMS replication subnet group"
  replication_subnet_group_id          = "${var.replication_instance_id}-subnet-group"

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  tags = local.context.tags
}

# Security group for DMS replication Instance
resource "aws_security_group" "dms_replication_instance_security_group" {
  #context = local.context

  name        = "${var.replication_instance_id}-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  tags        = local.context.tags
  description = "Security group for DMS replication instance."
}

# Think this SG needs to be attached to the source, target and fallback DBs too.

# Ingress and egress rules for DMS SG to access source, target, fallback RDS databases
resource "aws_security_group_rule" "replication_egress" {
  type                     = "egress"
  from_port                = data.aws_db_instance.source_database.port
  to_port                  = data.aws_db_instance.source_database.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dms_replication_instance_security_group.id
  source_security_group_id = data.aws_db_instance.source_database.vpc_security_groups[0]
  description              = "A rule to allow outgoing connections to the Source RDS PostgreSQL SG from the DMS Security Group"
}

resource "aws_security_group_rule" "replication_ingress" {
  type                     = "ingress"
  from_port                = data.aws_db_instance.source_database.port
  to_port                  = data.aws_db_instance.source_database.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dms_replication_instance_security_group.id
  source_security_group_id = data.aws_db_instance.source_database.vpc_security_groups[0]
  description              = "A rule to allow incoming connections from the Source RDS PostgreSQL SG to the DMS Security Group"
}

# We assume that the SG for the source, target and fallback DBs is the same
resource "aws_security_group_rule" "db_sg_egress" {
  type                     = "egress"
  from_port                = data.aws_db_instance.source_database.port
  to_port                  = data.aws_db_instance.source_database.port
  protocol                 = "tcp"
  security_group_id        = data.aws_db_instance.source_database.vpc_security_groups[0]
  source_security_group_id = aws_security_group.dms_replication_instance_security_group.id
  description              = "A rule to allow outgoing connections to the Source RDS PostgreSQL SG from the DMS Security Group"
}

resource "aws_security_group_rule" "db_sg_ingress" {
  type                     = "ingress"
  from_port                = data.aws_db_instance.source_database.port
  to_port                  = data.aws_db_instance.source_database.port
  protocol                 = "tcp"
  security_group_id        = data.aws_db_instance.source_database.vpc_security_groups[0]
  source_security_group_id = aws_security_group.dms_replication_instance_security_group.id
  description              = "A rule to allow incoming connections from the Source RDS PostgreSQL SG to the DMS Security Group"
}

# Create source endpoint (a) for a-to-b migration task (aka forward)
resource "aws_dms_endpoint" "forward_source_endpoint" {
  endpoint_id   = "${var.db_source_instance}-forward-source-ep"
  endpoint_type = "source"
  engine_name   = "postgres"
  server_name   = data.aws_db_instance.source_database.address
  database_name = var.source_database_name
  username      = data.aws_db_instance.source_database.master_username
  password      = var.db_master_password
  port          = data.aws_db_instance.source_database.port
  ssl_mode      = "require"

  tags = local.context.tags
}

# Create target endpoint (b) for a-to-b migration task (aka forward)
resource "aws_dms_endpoint" "forward_target_endpoint" {
  endpoint_id   = "${var.cluster_id}-${local.aurora_engine_major_version}-forward-target-ep"
  endpoint_type = "target"
  engine_name   = "aurora-postgresql"
  server_name   = data.aws_rds_cluster.target_database.endpoint
  database_name = var.target_database_name
  username      = data.aws_rds_cluster.target_database.master_username
  password      = var.db_master_password
  port          = data.aws_rds_cluster.target_database.port
  ssl_mode      = "require"

  tags = local.context.tags
}

# Create migration task for a-to-b replication (aka forward)
resource "aws_dms_replication_task" "dms_task_forward" {
  migration_type            = var.dms_forward_migration_type
  replication_instance_arn  = aws_dms_replication_instance.dms_instance.replication_instance_arn
  replication_task_id       = "${var.db_source_instance}-${var.cluster_id}-${local.aurora_engine_major_version}-${var.dms_forward_migration_type}"
  replication_task_settings = jsondecode(jsonencode(file("task_settings_forward.json")))
  source_endpoint_arn       = aws_dms_endpoint.forward_source_endpoint.endpoint_arn
  target_endpoint_arn       = aws_dms_endpoint.forward_target_endpoint.endpoint_arn
  table_mappings            = jsondecode(jsonencode(file("table_mappings.json")))

  tags = local.context.tags

}

# Create source endpoint (b) for b-to-c migration task (aka fallback)
resource "aws_dms_endpoint" "fallback_source_endpoint" {
  endpoint_id   = "${var.cluster_id}-${local.aurora_engine_major_version}-fallback-source-ep"
  endpoint_type = "source"
  engine_name   = "aurora-postgresql"
  server_name   = data.aws_rds_cluster.target_database.endpoint
  database_name = var.target_database_name
  username      = data.aws_rds_cluster.target_database.master_username
  password      = var.db_master_password
  port          = data.aws_rds_cluster.target_database.port
  ssl_mode      = "require"

  tags = local.context.tags
}

# Create target endpoint (c) for b-to-c migration task (aka fallback)
resource "aws_dms_endpoint" "fallback_target_endpoint" {
  endpoint_id   = "${var.db_fallback_instance}-fallback-target-ep"
  endpoint_type = "target"
  engine_name   = "postgres"
  server_name   = data.aws_db_instance.fallback_database.address
  database_name = var.fallback_database_name
  username      = data.aws_db_instance.fallback_database.master_username
  password      = var.db_master_password
  port          = data.aws_db_instance.fallback_database.port
  ssl_mode      = "require"

  tags = local.context.tags
}

# Create migration task for b-to-c replication (aka fallback)
resource "aws_dms_replication_task" "dms_task_fallback" {
  migration_type            = var.dms_fallback_migration_type
  replication_instance_arn  = aws_dms_replication_instance.dms_instance.replication_instance_arn
  replication_task_id       = "${var.cluster_id}-${local.aurora_engine_major_version}-${var.db_fallback_instance}-${var.dms_fallback_migration_type}"
  replication_task_settings = jsondecode(jsonencode(file("task_settings_fallback.json")))
  source_endpoint_arn       = aws_dms_endpoint.fallback_source_endpoint.endpoint_arn
  target_endpoint_arn       = aws_dms_endpoint.fallback_target_endpoint.endpoint_arn
  table_mappings            = jsondecode(jsonencode(file("table_mappings.json")))

  tags = local.context.tags

}
