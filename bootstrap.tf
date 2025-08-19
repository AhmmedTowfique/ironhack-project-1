terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

# S3 bucket
resource "aws_s3_bucket" "towfique_tf_state" {
  bucket        = "towfique-terraform-state"
  force_destroy = true
}

# DynamoDB table
resource "aws_dynamodb_table" "towfique_tf_locks" {
  name         = "towfique-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
