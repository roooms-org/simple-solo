provider "aws" {
  region = "${var.region}"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "random_pet" "main" {}

resource "aws_vpc" "main" {
  cidr_block           = "10.19.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name        = "${random_pet.main.id}_aws_vpc_main"
    Config_Name = "${random_pet.main.id}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${random_pet.main.id}_aws_internet_gateway_main"
    Config_Name = "${random_pet.main.id}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name        = "${random_pet.main.id}_aws_route_table_main"
    Config_Name = "${random_pet.main.id}"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_subnet" "public" {
  cidr_block              = "10.19.1.0/24"
  vpc_id                  = "${aws_vpc.main.id}"
  map_public_ip_on_launch = true
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"

  vars {
    pet_name = "${random_pet.main.id}"
  }
}

resource "aws_instance" "main" {
  ami                         = "${data.aws_ami.amazon_linux.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.public.id}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.user_data.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.main.id}",
  ]

  tags {
    Name        = "${random_pet.main.id}_aws_instance"
    Config_Name = "${random_pet.main.id}"
    Type        = "${var.instance_type}"
    owner       = "dan@hashicorp.com"
    ttl         = "-1"
  }
}

resource "aws_security_group" "main" {
  name        = "${random_pet.main.id}_aws_security_group_public"
  description = "${random_pet.main.id}_aws_security_group_public"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${random_pet.main.id}_aws_security_group_public"
    Config_Name = "${random_pet.main.id}"
  }
}
