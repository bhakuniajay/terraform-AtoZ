







# Simple test resource to verify remote backend
# resource "aws_s3_bucket" "firstbucket" {
#   bucket = local.bucket_name

#   tags = {
#     Name        = "Test Backend Bucket"
#     Environment = "${var.environment}-Dev-Bucket"
#   }
# }


# resource "random_string" "bucket_suffix" {
#   length  = 8
#   special = false
#   upper   = false
# }

# resource "aws_vpc" "sample" {
#   cidr_block = "10.0.1.0/24"
#   tags = {
#     Environment = "var.environment"
#     Name = "${var.environment}Dev-VPC"
#   }
# }

resource "aws_instance" "example" {
  instance_type = var.allowed_vm_types[1]
  count = var.instance_count
  ami = "ami-0c55b159cbfafe1f0"
  # region = tolist(var.allowed_region)[0]
  region = var.config.region
  tags = var.tags
  monitoring = var.monitoring
  associate_public_ip_address = var.associate_public_ip_address
  
}
 



resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[0]
  from_port         = var.ingress_values[0]
  ip_protocol       = var.ingress_values[1]
  to_port           = var.ingress_values[2]
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#tuple : multiple valuses , multiple data type tuple([no,string,no,string])
#set : unique , single variable 
#map : 
#distonary : type object