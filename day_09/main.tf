# # Data Sources
# # ==============================

# # Get the latest Amazon Linux 2 AMI
# data "aws_ami" "amazon_linux_2" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# # Get current AWS region
# data "aws_region" "current" {}

# # Get availability zones
# data "aws_availability_zones" "available" {
#   state = "available"
# }

# resource "aws_instance" "appservers" {
#   # ami = "ami-0ff8a91507f77f867"
#   ami = data.aws_ami.amazon_linux_2.id
#   instance_type = var.allowed_vm_types[1]
#   # region = tolist(var.allowed_region)[0]


#   # Not working 
#   # tags = merge(
#   #   var.resource_tags,
#   #   {
#   #     Name = var.instance_name 
#   #     Demo = "create_before_destroy"
#   #   }
#   # )

#   lifecycle {
#     create_before_destroy = true 
#   }


# }

# # resource "aws_autoscaling_group" "app_servers" {
# #   # ... other configuration ...
  
# #   desired_capacity = 2

# #   lifecycle {
# #     ignore_changes = [
# #       desired_capacity,  # Ignore capacity changes by auto-scaling
# #       load_balancers,    # Ignore if added externally
# #     ]
# #   }
# # }


# resource "aws_launch_template" "app_server" {
#   name_prefix = "app-server-"
#   image_id = data.aws_ami.amazon_linux_2.id
#   # instance_type = t2.micro
# }4
# #auto scaling group
# resource "aws_autoscaling_group" "appservers"{
#   name="app-server-asg"
#   desired_capacity = 2
#   max_size = 2
#   min_size = 1
#   health_check_type = "EC2"
#   availability_zones = [ "us-east-1a","us-east-1b" ]
#   launch_template {
#     id =aws_launch_template.app_server.id
#     version = "$Latest"
#   }
#   lifecycle {
#     ignore_changes = [ 
#       desired_capacity,
#      ]
#   }

# }



# ASG sg
resource "aws_security_group" "app_sg" {
  name = "app-security-group"
  description = "Security group for application server "
  ingress {
    from_port = 80
    to_port = 80
    protocol ="tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    description="allow HTTP from anywhere"
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol ="tcp"
    cidr_blocks =["0.0.0.0/0"]
    description="allow HTTPS from anywhere"
  }
  egress {
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
    description="alow all outbound traffic"

  }
  tags = var.tags
}



#  EC2 instance that gets replaced when security group changes 
resource "aws_instance" "name" {
    ami = "ami-0ff8a91507f77f867"
    instance_type = var.allowed_vm_types[0]
    vpc_security_group_ids = [aws_security_group.app_sg.id]
    tags = var.tags
    lifecycle {
      replace_triggered_by = [ 
        aws_security_group.app_sg.id 
      ]
    }
}

