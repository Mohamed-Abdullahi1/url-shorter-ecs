module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

data "aws_ecr_repository" "api" {
  name = "${var.project_name}/api"
}

data "aws_ecr_repository" "worker" {
  name = "${var.project_name}/worker"
}

data "aws_ecr_repository" "dashboard" {
  name = "${var.project_name}/dashboard"
}

data "aws_ecr_repository" "frontend" {
  name = "${var.project_name}/frontend"
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

  api_image       = "${data.aws_ecr_repository.api.repository_url}:${var.image_tag}"
  worker_image    = "${data.aws_ecr_repository.worker.repository_url}:${var.image_tag}"
  dashboard_image = "${data.aws_ecr_repository.dashboard.repository_url}:${var.image_tag}"
  frontend_image  = "${data.aws_ecr_repository.frontend.repository_url}:${var.image_tag}"

  base_url = "https://url.moabdullahi.uk"

  db_address  = module.rds.db_address
  db_name     = module.rds.db_name
  db_username = var.db_username
  db_password = var.db_password

  sqs_queue_url  = module.sqs.queue_url
  redis_endpoint = module.redis.redis_endpoint

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  alb_security_group_id      = module.alb.alb_security_group_id
  api_blue_target_group_arn  = module.alb.api_blue_target_group_arn
  api_green_target_group_arn = module.alb.api_green_target_group_arn
  api_listener_rule_arn      = module.alb.api_listener_rule_arn
  frontend_target_group_arn  = module.alb.frontend_target_group_arn

  api_5xx_alarm_name             = module.alb.api_5xx_alarm_name
  api_unhealthy_hosts_alarm_name = module.alb.api_unhealthy_hosts_alarm_name

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
  certificate_arn   = module.acm.certificate_arn

  tags = var.tags
}

module "acm" {
  source = "../../modules/acm"

  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id

  tags = var.tags
}

module "route53" {
  source = "../../modules/route53"

  hosted_zone_id = var.hosted_zone_id
  domain_name    = var.domain_name

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "waf" {
  source = "../../modules/waf"

  project_name = var.project_name
  alb_arn      = module.alb.alb_arn

  tags = var.tags
}
