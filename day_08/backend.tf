terraform {
    backend "s3" {
    bucket         = "mybucketajay11"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile  = true
    encrypt        = true
  }  
}