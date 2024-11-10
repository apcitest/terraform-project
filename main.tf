provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "apci-jupiter-tf-state-bucket"   # Replace with your S3 bucket name
    key            = "apci/jupiter/terraform.tfstate" # The path within the bucket to store the state file. You can structure it according to your project.
    region         = "us-east-1"                      # Region where the S3 bucket is located
    dynamodb_table = "apci-jupiter-tfs-lock-table"    # DynamoDB table for state locking
    encrypt        = true                             # Encrypt state file using S3 default encryption
  }
}

module "vpc" {
  source              = "./vpc"
  vpc_cidr_block      = var.vpc_cidr_block
  tags                = local.project_tags
  frontend_cidr_block = var.frontend_cidr_block
  availability_zone   = var.availability_zone
  backend_cidr_block  = var.backend_cidr_block
}

module "alb" {
  source                   = "./alb"
  frontend_subnet_az_1a_id = module.vpc.frontend_subnet_az_1a_id
  frontend_subnet_az_1b_id = module.vpc.frontend_subnet_az_1b_id
  tags                     = local.project_tags
  ssl_policy               = var.ssl_policy
  vpc_id                   = module.vpc.vpc_id
  certificate_arn          = var.certificate_arn
}

module "auto-scaling" {
  source                   = "./auto-scaling"
  instance_type            = var.instance_type
  key_name                 = var.key_name
  frontend_subnet_az_1a_id = module.vpc.frontend_subnet_az_1a_id
  frontend_subnet_az_1b_id = module.vpc.frontend_subnet_az_1b_id
  alb_sg_id                = module.alb.alb_sg_id
  target_group_arn         = module.alb.target_group_arn
  image_id                 = var.image_id
  vpc_id                   = module.vpc.vpc_id
}

module "route53" {
  source       = "./route53"
  alb_dns_name = module.alb.alb_dns_name
  dns_name     = var.dns_name
  zone_id      = var.zone_id
  alb_zone_id  = module.alb.alb_zone_id
}

module "ec2" {
  source                   = "./ec2"
  tags                     = local.project_tags
  vpc_id                   = module.vpc.vpc_id
  key_name                 = var.key_name
  backend_subnet_az_1a_id  = module.vpc.backend_subnet_az_1a_id
  backend_subnet_az_1b_id  = module.vpc.backend_subnet_az_1b_id
  image_id                 = var.image_id
  frontend_subnet_az_1a_id = module.vpc.frontend_subnet_az_1a_id
  instance_type            = var.instance_type
}

module "rds" {
  source               = "./rds"
  vpc_id               = module.vpc.vpc_id
  tags                 = local.project_tags
  instance_class       = var.instance_class
  username             = var.username
  parameter_group_name = var.parameter_group_name
  engine_version       = var.engine_version
  db_subnet_az_1a_id   = module.vpc.db_subnet_az_1a_id
  db_subnet_az_1b_id   = module.vpc.db_subnet_az_1b_id
  password             = var.password
  vpc_cidr_block       = var.vpc_cidr_block
}