provider "aws" {
  region = "us-west-2"
}

terraform {
  required_version = ">= 0.9.4"

  backend "s3" {
    region     = "us-west-2"
    lock_table = "tf_meta"
    bucket     = "mwoo-tf-remote-state"
    key        = "simple_02/terraform.tfstate"
  }
}



resource "aws_vpc" "tf_simple" {
  cidr_block = "10.0.0.0/19"

  tags {
    Name = "${var.stackname}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.tf_simple.id}"

  tags {
    Name = "${var.stackname}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.tf_simple.id}"
  cidr_block = "10.0.0.0/24"

  tags {
    Name = "${var.stackname}_public1"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.tf_simple.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "${var.stackname}_public"
  }
}

resource "aws_route_table_association" "public_route_assoc" {
  subnet_id = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public_route.id}"
}
