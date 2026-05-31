terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  #region = "us-east-1"
  region = var.region
}

resource "aws_instance" "virtual-server" {
  ami="ami-051a31ab2f4d498f5" #AmazonLunix 2023
  instance_type = "t3.micro"

  tags = {
    Name="SimpleServer"
  }
}
