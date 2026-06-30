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
