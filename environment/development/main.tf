module "vpc" {
  source = "../..//modules/vpc" # path details
  aws_vpc = {
    cidr_block = "10.0.0.0/16" # vpc cidr block
  }
  aws_subnet = {
    cidr_block         = "10.0.1.0/24"                                # subnet cidr block
    availability_zones = ["${var.env.region}a", "${var.env.region}b"] # ap-south-1a, ap-south-1b
  }
  env = var.env.name # development environment

  tags = {
    Name = "${var.env.name}-vpc"
  }
}

module "ec2" {
  source = "../..//modules/ec2" # path details
  ec2_config = {
    ami_id             = "ami-0037855f86d0a04b4"        # amazon linux 2023
    instance_type      = "t2.large"                     # instance type
    volume             = 30                             # volume size (GiB)
    vpc_id             = module.vpc.vpc_id              # vpc id
    subnet_id          = module.vpc.subnet_id           # subnet id
    ec2_count          = 2                              # number of instances
    env                = var.env.name                   # development environment
    security_group_ids = [module.vpc.security_group_id] # security group in the new vpc
    key_name           = "mumbai_key"                   # EC2 key pair name (not the .ppk file name)
  }

  tags = {
    Name = "${var.env.name}-ec2"
  }
}

output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "instance_ids" {
  description = "EC2 instance ids"
  value       = module.ec2.instance_ids
}

output "private_ips" {
  description = "EC2 private IPs"
  value       = module.ec2.private_ips
}
