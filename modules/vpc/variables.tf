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

variable "ingress_cidrs" {
  description = "CIDRs allowed inbound on all TCP ports"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Extra tags for the VPC"
  type        = map(string)
  default     = {}
}
