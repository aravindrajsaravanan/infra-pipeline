resource "aws_vpc" "myvpc" {
  cidr_block       = var.aws_vpc.cidr_block
  instance_tenancy = "default"

  tags = merge({ Name = "${var.env}-vpc", env = var.env }, var.tags)
}

resource "aws_subnet" "mysubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.aws_subnet.cidr_block
  availability_zone = var.aws_subnet.availability_zones[0]

  tags = {
    Name = "${var.env}-subnet"
    env  = var.env
  }
}

output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.myvpc.id
}

output "subnet_id" {
  description = "Subnet id"
  value       = aws_subnet.mysubnet.id
}
