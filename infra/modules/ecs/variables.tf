variable "project_name" {
  description = "Project name used as a prefix for resource names"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "worker_image" {
  type = string
}

variable "dashboard_image" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "api_image" {
  type = string
}

variable "db_address" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "sqs_queue_url" {
  type = string
}

variable "redis_endpoint" {
  type = string
}

variable "base_url" {
  type    = string
  default = "http://localhost"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "api_blue_target_group_arn" {
  type = string
}

variable "api_green_target_group_arn" {
  type = string
}

variable "api_listener_rule_arn" {
  type = string
}

variable "sqs_queue_arn" {
  type = string
}

variable "api_5xx_alarm_name" {
  type = string
}

variable "api_unhealthy_hosts_alarm_name" {
  type = string
}

variable "frontend_image" {
  description = "Frontend container image"
  type        = string
}

variable "frontend_target_group_arn" {
  description = "Frontend target group ARN"
  type        = string
}

variable "rds_security_group_id" {
  description = "Security group ID for the RDS database"
  type        = string
}

variable "redis_security_group_id" {
  description = "Security group ID for the Redis cluster"
  type        = string
}
