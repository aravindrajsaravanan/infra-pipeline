variable "aws_vpc" {
  description = "vpc resource"
  type = object({
    cidr_block = string
  })
}

variable "aws_subnet" {
  description = "subnet resource"
  type = object({
    cidr_block         = string
    availability_zones = list(string)
  })
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Extra tags for the VPC"
  type        = map(string)
  default     = {}
}
