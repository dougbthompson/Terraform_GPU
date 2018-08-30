data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180814"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]

  # ami-0552e3455b9bc8d50
}

resource "aws_instance" "NodeA" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  subnet_id                   = "${aws_subnet.subnet1.id}"
  vpc_security_group_ids      = ["${aws_security_group.g1_security.id}"]
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  key_name                    = "DB_EC2_Ohio_01"
  iam_instance_profile        = "DB_EC2_Setup"

# elastic_gpu_specifications {
#   type = "eg1.medium"
# }

  root_block_device {
    volume_type           = "standard"
    volume_size           = "96"
    delete_on_termination = true
  }

  tags {
    Name = "EC2-USE2A-G1-NODEA"
  }
}

