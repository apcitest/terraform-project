variable "vpc_cidr_block" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "frontend_cidr_block" {
  type = list(string)
}

variable "availability_zone" {
  type =list(string)
}

variable "backend_cidr_block" {
  type = list(string)
}
