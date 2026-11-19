variable "ec2_config" {
  description = "All settings for my EC2 instances"
  type = object({
    ami_id             = string
    instance_type      = string
    volume             = number
    vpc_id             = string
    subnet_id          = string
    ec2_count          = number
    env                = string
    security_group_ids = list(string)
    key_name           = string
  })
}

variable "tags" {
  description = "Extra tags for the instances"
  type        = map(string)
  default     = {}
}
