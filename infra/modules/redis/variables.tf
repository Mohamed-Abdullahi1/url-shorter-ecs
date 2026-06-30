variable "project_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "engine_version" {
  type    = string
  default = "7.1"
}

variable "node_type" {
  type    = string
  default = "cache.t4g.micro"
}

variable "parameter_group_name" {
  type    = string
  default = "default.redis7"
}

variable "tags" {
  type    = map(string)
  default = {}
}
