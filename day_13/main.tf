data "aws_vpc" "vpc_name" {
  filter {
    name = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnet" "shared" {
  filter {
    name = "tag:Name"
    values = ["subneta"]
  }
  vpc_id = data.aws_vpc.vpc_name.id
}

data "aws_ami" "linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "example" {
  count = var.instance_count
  ami = data.aws_ami.linux2.id
  instance_type = "t2.micro"
  tags = var.tags
  subnet_id = data.aws_subnet.shared.id


}
