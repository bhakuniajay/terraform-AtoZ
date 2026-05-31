terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random ={
      source = "hashicorp/random"
      version = "3.6.2"
    }
  }
}


provider "aws" {
  #region = "us-east-1"
  region = var.region
}
resource "random_id" "bucket_random_name_id" {
  byte_length = 8
}

resource "aws_s3_bucket_acl" "demo_acl" {
  bucket = aws_s3_bucket.demo_bucket.id
  acl    = "private"
}
resource "aws_s3_bucket" "demo_bucket" {
    bucket = "demo-bucket-${random_id.bucket_random_name_id.hex}"
    }
resource "aws_s3_object" "bucket-data" {
    bucket = aws_s3_bucket.demo_bucket
    source = "./demo.txt"
    key = "mydemo.txt"
}
output "name" {
  value = random_id.bucket_random_name_id.b64_url
}