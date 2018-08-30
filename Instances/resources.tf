# new vpc/subnet configuration

resource "aws_vpc" "g1" {
  cidr_block           = "172.33.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "G1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.g1.id}"

  tags {
    Name = "G1 GW"
  }
}

resource "aws_route_table" "g1_rt" {
  vpc_id = "${aws_vpc.g1.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "G1 GW"
  }
}

resource "aws_main_route_table_association" "mrt" {
  vpc_id         = "${aws_vpc.g1.id}"
  route_table_id = "${aws_route_table.g1_rt.id}"
}

resource "aws_subnet" "subnet1" {
  cidr_block              = "${cidrsubnet(aws_vpc.g1.cidr_block, 4, 1)}"
  vpc_id                  = "${aws_vpc.g1.id}"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "s1rt" {
  subnet_id      = "${aws_subnet.subnet1.id}"
  route_table_id = "${aws_route_table.g1_rt.id}"
}

# Office: 209.232.226.99 
#   Home: 73.189.152.222

resource "aws_security_group" "g1_security" {
  vpc_id      = "${aws_vpc.g1.id}"
  name        = "DB_EC2_G1"
  description = "Allow (G1) gpu traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["209.232.226.99/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["73.189.152.222/32"]
  }
  ingress {
    from_port   = 2007
    to_port     = 2007
    protocol    = "tcp"
    cidr_blocks = ["209.232.226.99/32"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

