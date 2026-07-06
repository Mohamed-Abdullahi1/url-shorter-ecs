module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "ecr" {
  source = "../../modules/ecr"

  project_name     = var.project_name
  repository_names = var.repository_names

  tags = var.tags
}

module "rds" {
  source = "../../modules/rds"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  db_password = var.db_password

  tags = var.tags
}

module "sqs" {
  source = "../../modules/sqs"

  project_name = var.project_name

  tags = var.tags
}

module "redis" {
  source = "../../modules/redis"

  project_name       = var.project_name
  environment        = "dev"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  tags = var.tags
}

module "ecs" {
  source = "../../modules/ecs"

  project_name = var.project_name

  api_image       = "${module.ecr.repository_urls["api"]}:latest"
  worker_image    = "${module.ecr.repository_urls["worker"]}:latest"
  dashboard_image = "${module.ecr.repository_urls["dashboard"]}:latest"

  db_address  = module.rds.db_address
  db_name     = module.rds.db_name
  db_username = var.db_username
  db_password = var.db_password

  sqs_queue_url  = module.sqs.queue_url
  redis_endpoint = module.redis.redis_endpoint

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  alb_security_group_id = module.alb.alb_security_group_id
  api_target_group_arn  = module.alb.api_target_group_arn

  rds_security_group_id   = module.rds.security_group_id
  redis_security_group_id = module.redis.security_group_id

  sqs_queue_arn = module.sqs.queue_arn

  tags = var.tags
}

module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  tags = var.tags
}
