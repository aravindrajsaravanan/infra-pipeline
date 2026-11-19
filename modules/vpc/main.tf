resource "aws_vpc" "myvpc" {
  cidr_block       = var.aws_vpc.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.aws_vpc.env}-vpc"
  }
}

resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.aws_subnet.cidr_block
  availability_zone = "${var.availability_zones[0]}"

  tags = {
    Name = "${var.aws_vpc.env}-subnet"
  }
}

output "vpc_id" {
  value = aws_vpc.myvpc.id
}

output "subnet_id" {
  value = aws_subnet.mysubnet.id
}