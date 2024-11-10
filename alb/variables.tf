variable "vpc_id" {
  type = string
}

variable "frontend_subnet_az_1a_id" {
  type = string
}

variable "frontend_subnet_az_1b_id" {
  type = string
}

variable "tags" {
  type = map(string)
}


variable "certificate_arn" {
  type = string
}

variable "ssl_policy" {
  type = string
}