module "vpc" {
  source = "../..//modules/vpc" # path details
  aws_vpc = {
    cidr_block = "10.0.0.0/16"  # vpc cidr block
  }
  aws_subnet = {
    cidr_block = "10.0.1.0/24"  # subnet cidr block
    availability_zones = ["${var.env.region}a", "${var.env.region}b"] # ap-south-1a, ap-south-1b
  }
  env = var.env.name # development environment

  tags = {
    Name = "${var.env.name}-vpc"
  }
}

module "ec2" {
  source        = "../..//modules/ec2"          # path details
  ami_id        = "ami-0037855f86d0a04b4"       # amazon linux 2
  instance_type = "t2.large"                    # instance type
  volume        = 30                            # volume size
  vpc_id        = module.vpc.vpc_id             # vpc id
  subnet_id     = module.vpc.subnet_id          # subnet id
  count         = 2                             # number of instances
  env           = var.env.name                  # development environment
  security_group_ids = ["sg-0d678ad25e20d8617"] # security group ids
  key_pair_login = "mumbai_key.ppk"             # key pair name

  tags = {
    Name = "${var.env.name}-ec2"
  }
}