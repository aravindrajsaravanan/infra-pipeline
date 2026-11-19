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

resource "aws_security_group" "mysg" {
  name        = "${var.env}-ec2-sg"
  description = "EC2 security group for ${var.env}"
  vpc_id      = aws_vpc.myvpc.id

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-ec2-sg"
    env  = var.env
  }
}

output "security_group_id" {
  description = "EC2 security group id"
  value       = aws_security_group.mysg.id
}

output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.myvpc.id
}

output "subnet_id" {
  description = "Subnet id"
  value       = aws_subnet.mysubnet.id
}
