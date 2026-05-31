# resource "aws_vpc" "primary_vpc" {
#   cidr_block       =var.primary_vpc_cidr_block
#   provider = aws.primary #alias in provider.tf
#   instance_tenancy = "default"
#   enable_dns_support = true
#   enable_dns_hostnames = true
#   tags = {
#     Name = "primary-VPC-${var.primary}"
#   }
# }

# resource "aws_vpc" "secondry_vpc" {
#   cidr_block       = var.secondry_vpc_cidr_block
#   provider = aws.secondry #alias in provider.tf
#   instance_tenancy = "default"
#   enable_dns_support = true
#   enable_dns_hostnames = true
#   tags = {
#     Name = "primary-VPC-${var.secondry}"
#   }
# }

# #VPC Created 

# #Creating subnet
# resource "aws_subnet" "prinmary_subnet"{
#   provider = aws.primary
#   vpc_id = aws_vpc.primary_vpc.id
#   cidr_block = var.primary_vpc_cidr_block
#   availability_zone = data.aws_availability_zones.primary.names[0]
#   tags = {
#     Name = " Primary-Subnet-${var.primary}"
#     Envirnonment = "Demo"
#   }
# }

# resource "aws_subnet" "secondry_subnet"{
#   provider = aws.primary
#   vpc_id = aws_vpc.secondry_vpc.id
#   cidr_block = var.secondry_vpc_cidr_block
#   availability_zone = data.aws_availability_zones.secondry.names[1]
#   # availability_zone = data.aws_availability_zones.secondry[1]
#   map_public_ip_on_launch = true
#   tags = {
#     Name = " Secondry-Subnet-${var.secondry}"
#     Envirnonment = "Demo"
#   }
# }



# resource "aws_internet_gateway" "primary_igw" {
#   provider = aws.primary
#   vpc_id=aws_vpc.primary_vpc.id
#   tags = {
#     Name = "Priamary Internet Gateway - ${var.primary}"
#     Envirnonment ="Demo"
#   }
# }

# resource "aws_internet_gateway" "secondry_igw" {
#   provider = aws.secondry
#   vpc_id=aws_vpc.secondry_vpc.id
#   tags = {
#     Name = "Priamary Internet Gateway - ${var.secondry}"
#     Envirnonment ="Demo"
#   }
# }


# resource "aws_route_table" "primary_rt" {
#   provider = aws.primary
#   vpc_id = aws_vpc.primary_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.primary_igw.id
#   }
#   tags = {
#     Name = "Priamary Route Table - ${var.primary}"
#     Envirnonment ="Demo"
#   }
# }

# resource "aws_route_table" "secondry_rt" {
#   provider = aws.secondry
#   vpc_id = aws_vpc.secondry_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.secondry_igw.id
#   }
#   tags = {
#     Name = "Secondry Route Table - ${var.secondry}"
#     Envirnonment ="Demo"
#   }
# }

# resource "aws_route_table_association" "primary_rta" {
#   provider = aws.primary
#   subnet_id = aws_subnet.prinmary_subnet.id
#   route_table_id = aws_route_table.primary_rt.id
# }
# resource "aws_route_table_association" "secondry_rta" {
#   provider = aws.secondry
#   subnet_id = aws_subnet.secondry_subnet.id
#   route_table_id = aws_route_table.secondry_rt.id
# }


# resource "aws_vpc_peering_connection_accepter" "primary_accepter" {
#   provider = aws.primary
#   vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondry.vpc_id
#   auto_accept = true
#   tags ={
#     Name = "Primary-to-secondry-Peering"
#     Envirnonment ="Demo"
#   }
# }

# resource "aws_vpc_peering_connection_accepter" "secondry_accepter" {
#   provider = aws.secondry
#   vpc_peering_connection_id = aws_vpc_peering_connection.secondry_to_primary.vpc_id
#   auto_accept = true
#   tags ={
#     Name = "Secondry-to-Primary-Peering"
#     Envirnonment ="Demo"
#   }
# }


# resource "aws_route" "primary_to_secondry" {
#   provider = aws.primary
#   route_table_id = aws_route_table.primary_rt.id
#   destination_cidr_block = var.secondry_vpc_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondry
#   depends_on = [ aws_vpc_peering_connection_accepter.secondry_accepter ]
# }

# resource "aws_route" "secondry_to_primary" {
#   provider = aws.secondry
#   route_table_id = aws_route_table.secondry_rt.id
#   destination_cidr_block = var.primary_vpc_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.secondry_to_primary
#   depends_on = [ aws_vpc_peering_connection_accepter.secondry_accepter ]
# }


resource "aws_vpc" "primary_vpc" {
  cidr_block       = var.primary_vpc_cidr
  
  provider = aws.primary
  enable_dns_hostnames = true
  enable_dns_support = true 
  tags = {
    Name = "Primary-VPC"
  }
}
resource "aws_vpc" "secondry_vpc" {
  cidr_block       = var.secondary_vpc_cidr
  provider = aws.secondry
  enable_dns_hostnames = true
  enable_dns_support = true 
  tags = {
    Name = "Secondry-VPC"
  }
}


resource "aws_subnet" "primary_subnet" {
  vpc_id     = aws_vpc.primary_vpc.id
  cidr_block = var.primary_vpc_cidr
  #Based on region we are selecting first avalability zone
  availability_zone = data.aws_availability_zones.primary.names[0]

  tags = {
    Name = "Secondry-subnet-{$var.secondry}"
  }
}

resource "aws_subnet" "secondry_subnet" {
  vpc_id     = aws_vpc.secondry_vpc.id
  cidr_block = var.secondary_vpc_cidr
  #Based on region we are selecting first avalability zone
  availability_zone = data.aws_availability_zones.secondry.names[0]

  tags = {
    Name = "Secondry-subnet-{$var.secondry}"
  }
}

#Internet gateway

resource "aws_internet_gateway" "primary_igw"{
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id
  tags = {
    Name = "Primary-IGW"
  }
}

resource "aws_internet_gateway" "secondry_igw"{
  provider = aws.secondry
  vpc_id = aws_vpc.secondry_vpc.id
  tags = {
    Name = "Secondry-IGW"
  }
}

#route table 

resource "aws_route_table" "primary_rt"{
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }
  tags = {
    Name = "Primary route table "
  }
}

resource "aws_route_table" "secondry_rt"{
  provider = aws.secondry
  vpc_id = aws_vpc.secondry_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondry_igw.id
  }
  tags = {
    Name = "Secondry route table "
  }
}

#route table connect subnet

resource "aws_route_table_association" "primary_rta"{
  provider =aws.primary
  subnet_id =aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_rt.id

}
# aws_route_table_association
resource "aws_route_table_association" "secondry_rta"{
  provider =aws.secondry
  subnet_id =aws_subnet.secondry_subnet.id
  route_table_id = aws_route_table.secondry_rt.id

}

#VPC peering connection from a to b and b to a VPC PEering
resource "aws_vpc_peering_connection" "primary_to_secondry" {
  provider = aws.primary
  vpc_id =aws_vpc.primary_vpc.id
  peer_vpc_id = aws_vpc.secondry_vpc.id  #destination 
  peer_region = var.secondary_region
  auto_accept = false

}

resource "aws_vpc_peering_connection_accepter" "secondry_acceptor" {
  provider = aws.secondry
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondry.id

  auto_accept = true

}


resource "aws_route" "primarytosecondry" {
  provider = aws.primary
  route_table_id = aws_route_table.primary_rt.id
  destination_cidr_block = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondry.id
  depends_on = [ aws_vpc_peering_connection_accepter.secondry_acceptor ]
}

resource "aws_route" "secondrytoprimary" {
  provider = aws.secondry
  route_table_id = aws_route_table.secondry_rt.id
  destination_cidr_block = var.primary_subnet_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondry.id
  depends_on = [ aws_vpc_peering_connection_accepter.secondry_acceptor ]
}

# Security Group for Primary VPC EC2 instance
resource "aws_security_group" "primary_sg" {
  provider    = aws.primary
  name        = "primary-vpc-sg"
  description = "Security group for Primary VPC instance"
  vpc_id      = aws_vpc.primary_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  ingress {
    description = "All traffic from Secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Primary-VPC-SG"
    Environment = "Demo"
  }
}

# Security Group for Secondary VPC EC2 instance
resource "aws_security_group" "secondary_sg" {
  provider    = aws.secondary
  name        = "secondary-vpc-sg"
  description = "Security group for Secondary VPC instance"
  vpc_id      = aws_vpc.secondry_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Secondary-VPC-SG"
    Environment = "Demo"
  }
}

# EC2 Instance in Primary VPC
resource "aws_instance" "primary_instance" {
  provider               = aws.primary
  ami                    = data.aws_ami.primary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.primary_subnet.id
  vpc_security_group_ids = [aws_security_group.primary_sg.id]
  key_name               = var.primary_key_name

  user_data = local.primary_user_data

  tags = {
    Name        = "Primary-VPC-Instance"
    Environment = "Demo"
    Region      = var.primary_region
  }

  depends_on = [aws_vpc_peering_connection_accepter.secondry_acceptor]
}

# EC2 Instance in Secondary VPC
resource "aws_instance" "secondary_instance" {
  provider               = aws.secondary
  ami                    = data.aws_ami.secondry_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.secondry_subnet.id
  vpc_security_group_ids = [aws_security_group.secondary_sg.id]
  key_name               = var.secondary_key_name

  user_data = local.secondary_user_data

  tags = {
    Name        = "Secondary-VPC-Instance"
    Environment = "Demo"
    Region      = var.secondary_region
  }

  depends_on = [ aws_vpc_peering_connection_accepter.secondry_acceptor ]
}