variable "db_subnet_az_1a_id" {
  type = string
}

variable "db_subnet_az_1b_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "parameter_group_name" {
  type = string
}