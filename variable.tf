variable "vpc_cidr_block" {
  type = string
}

variable "frontend_cidr_block" {
  type = list(string)
}

variable "availability_zone" {
  type = list(string)
}

variable "backend_cidr_block" {
  type = list(string)
}

variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "ssl_policy" {
  type = string
}

variable "dns_name" {
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