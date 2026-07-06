variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
}

variable "domain_validation_options" {
  description = "ACM DNS validation options"
  type        = any
}

variable "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  type        = string
}

variable "alb_zone_id" {
  description = "Application Load Balancer Hosted Zone ID"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
