variable "project_name" {
  type    = string
  default = "url-shortener"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "repository_names" {
  type    = list(string)
  default = ["api"]
}

variable "tags" {
  type = map(string)

  default = {
    Project     = "url-shortener"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "db_password" {
  type      = string
  sensitive = true
}
