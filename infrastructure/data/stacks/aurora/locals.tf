# ==============================================================================
# Context

locals {
  # replicas = var.replica_set != null ? toset(split(",",var.replica_set)) : toset([])
  aurora_engine_major_version = element((split(".", var.aurora_engine_version)), 0)
 
}




