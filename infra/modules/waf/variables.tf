variable "project_name" {
  type = string
}

variable "alb_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
