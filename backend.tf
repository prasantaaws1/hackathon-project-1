# resource "aws_s3_bucket" "mybucket" {
#   bucket = "hacka-thon-mar-2025-1"
#   versioning {
#     enabled = true
#   }
# }


# resource "aws_dynamodb_table" "statelock" {
#   name         = "state-lock-1"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }



# # terraform {
# #   backend "s3" {
# #     bucket  = "hacka-thon-2025"
# #     region  = "ap-south-1"
# #     key     = "s3-github-actions/terraform.tfstate"
# #     encrypt = true
# #   }
# #   required_version = ">=0.13.0"
# #   required_providers {
# #     aws = {
# #       version = ">= 2.7.0"
# #       source  = "hashicorp/aws"
# #     }
# #   }
# # }
