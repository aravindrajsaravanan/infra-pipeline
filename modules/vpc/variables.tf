variable "aws_vpc" {
  description = "vpc resource"
  type = object({
    cidr_block       = string
    env              = map(string)
  })
}

variable "aws_subnet" {
  description = "subnet resource"
  type = object({
    vpc_id     = string
    cidr_block = string
  })
}

variable "availability_zones" {
  description = "List of availability zones"
  type = list(string)
}