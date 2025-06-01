provider "aws" {
    region = "ap-south-1"
    access_key = "your access key here"
    secret_key = "your secret key here"
}

resource "aws_instance" "my-ec2" {
    ami                    = "ami-06b6e5225d1db5f46"
    instance_type          = "t2.micro"
    count                  = 1
    key_name               = aws_key_pair.ec2-key-pair.key_name
    subnet_id              = aws_subnet.my-subnet.id
    vpc_security_group_ids = [aws_security_group.my-sg.id]
    associate_public_ip_address = true

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 
                sudo systemctl enable apache2
                sudo systemctl start apache2
                EOF
}

resource "aws_key_pair" "ec2-key-pair" {
  key_name = "instance-key-pair"
  public_key = file("")
}

resource "aws_vpc" "my-vpc" {
  cidr_block =      "10.0.0.0/16"
}

resource "aws_subnet" "my-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "my-sg" {
  vpc_id = aws_vpc.my-vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my-vpc.id

route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "my-rta" {
  subnet_id      = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.my-rt.id
}

output "instance_public_ip" {
  description = "public ip address of the instance"
  value = aws_instance.my-ec2[0].public_ip
}
