locals {
  name = "${var.project_name}-${var.environment}-redis"
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${local.name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${local.name}-subnet-group"
  })
}

resource "aws_security_group" "redis" {
  name        = "${local.name}-sg"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${local.name}-sg"
  })
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = local.name
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = 1
  port                 = 6379
  parameter_group_name = var.parameter_group_name

  subnet_group_name  = aws_elasticache_subnet_group.redis.name
  security_group_ids = [aws_security_group.redis.id]

  tags = merge(var.tags, {
    Name = local.name
  })
}
