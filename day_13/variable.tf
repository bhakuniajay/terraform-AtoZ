
variable "region" {
  default = "us-east-1"
}
variable "environment" {
  type = string
}
variable "bucketname" {
  default = "mybucket11"
}
variable "instance_count" {
  type = number
  description = "Number of EC2 instace to create"
}
variable "monitoring" {
  type = bool
  default = true
}

variable "associate_public_ip_address" {
  default = true
}

variable "cidr_block" {
  type = list(string)
  description = "CIDR block for the VPC"
  default = ["10.0.0.0/8" , "192.168.0.0/12"]
}

variable "allowed_vm_types"{
  type = list(string)
  default = ["t2.micro","t2.small","t3.micro","t3.small"]
}

variable "allowed_region" {
  description = "list of allowed AWS regions"
  type = set(string)
  default = [ "us-east-1","us-east-2"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "var.environment"
    Name = "Dev-Instace"
  }
  
  
}

variable "ingress_values" {
  type = tuple([ number , string , number])
  default = [ 443 , "tcp" , 443 ]
}

variable "config" {
  type = object({
    region  = string,
    monitoring=bool,
    instance_count=number
  })
  default = {
    region = "us-east-1"
    monitoring = true,
    instance_count = 1
  }
  
}

variable "bucket_names" {
  description = "List of S3 bucket name"
  type = list(string)
  default = [ "my-uniquie-bucket-day08-A" , "my-uniquie-bucket-day08-B", "my-uniquie-bucket-day08-C"]
}

variable "bucket_names_set" {
  description = "List of S3 bucket name"
  type = set(string)
  default = [ "my-uniquie-bucket-day08-AA" , "my-uniquie-bucket-day08-B", "my-uniquie-bucket-day08-CC"]
}

variable "ingress_rules" {
  description = "List of ingress rules for security group"
  type = list(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string) 
    description =string
  }))
default = [ 
  {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTP"
  } ,
  {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTPS"
  }
]
}
