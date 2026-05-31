  terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "demo-bucket9911"
    key    = "backendtf.state"
    region = "ap-south-1"
  }
}
provider "aws" {
  #region = "us-east-1"
  region = "ap-south-1"
}

resource "aws_instance" "virtual-server" {
  ami="ami-051a31ab2f4d498f5" #AmazonLunix 2023
  instance_type = "t3.micro"

  tags = {
    Name="SimpleServer"
  }
}
