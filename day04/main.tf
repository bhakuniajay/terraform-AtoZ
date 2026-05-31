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

variable "region" {
  default = "us-east-1"
}
variable "environment" {
  default = "dev"
  type = string
}
variable "bucketname" {
  default = "mybucket11"
}

locals {

  bucket_name="${var.bucketname}-bucket-${var.environment}"

}

provider "aws" {
  region = var.region
#   region = ap-south-1
}

terraform {
  backend "s3" {
    bucket         = "mybucketajay11"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile  = true
    encrypt        = true
  }
}




locals {
  env =var.environment
  bucket_name ="test-remote-backend-bucket-${var.environment}-{$var.region}"
}

# Simple test resource to verify remote backend
resource "aws_s3_bucket" "firstbucket" {
  bucket = local.bucket_name

  tags = {
    Name        = "Test Backend Bucket"
    Environment = "${var.environment}-Dev-Bucket"
  }
}


resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_vpc" "sample" {
  cidr_block = "10.0.1.0/24"
  tags = {
    Environment = "var.environment"
    Name = "${var.environment}Dev-VPC"
  }
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami = "ami-0c55b159cbfafe1f0"
  tags = {
    Environment = "var.environment"
    Name = "${var.environment}-EC2-Instance"
  }
}
