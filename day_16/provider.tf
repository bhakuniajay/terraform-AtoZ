terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

# OLD alias (needed for existing state)
# provider "aws" {
#   alias  = "secondry"
#   region = "us-west-2"
# }

# # NEW alias
# provider "aws" {
#   alias  = "secondary"
#   region = "us-west-2"
# }