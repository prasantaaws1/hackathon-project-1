provider "aws" {
  region = var.aws_region
}


terraform {
  backend "s3" {
    bucket         = "hacka-thon-mar-2025-1"
    dynamodb_table = "state-lock-1"
    key            = "global/mystatefile-1/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}


module "vpc" {
  source      = "./modules/network"
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
  # az_count    = "1"
}

module "ecs_app" {
  source                       = "./modules/ecs"
  ec2_task_execution_role_name = "EcsTaskExecutionRoleName"
  ecs_auto_scale_role_name     = "EcsAutoScaleRoleName"
  app_image                    = "167365792572.dkr.ecr.us-west-1.amazonaws.com/django-app:production"
  app_port                     = 8000
  app_count                    = 1
  health_check_path            = "/"
  fargate_cpu                  = "1024"
  fargate_memory               = "2048"
  aws_region                   = terraform.workspace
  az_count                     = "2"
  subnets                      = module.network.public_subnet_ids
  sg_ecs_tasks                 = [module.security.ecs_tasks_security_group_id]
  vpc_id                       = module.network.vpc_id
  lb_security_groups           = [module.security.alb_security_group_id]
}

module "security" {
  source   = "./modules/security"
  app_port = 80
  vpc_id   = module.network.vpc_id
}

# resource "aws_s3_bucket_ownership_controls" "example" {
#   bucket = aws_s3_bucket.example.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "example" {
#   depends_on = [aws_s3_bucket_ownership_controls.example]

#   bucket = aws_s3_bucket.example.id
#   acl    = "private"
# }

# resource "aws_s3_bucket_public_access_block" "example" {
#   bucket = aws_s3_bucket.example.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket_versioning" "versioning_example" {
#   bucket = aws_s3_bucket.example.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_kms_key" "mykey" {
#   description             = "This key is used to encrypt bucket objects"
#   enable_key_rotation     = true
#   deletion_window_in_days = 7
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
#   bucket = aws_s3_bucket.example.id

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.mykey.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }
