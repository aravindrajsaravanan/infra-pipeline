variable "env" {
  description = "Environment name and AWS region"
  type = object({
    name   = string
    region = string
  })
  default = {
    name   = "development", # dev environment
    region = "ap-south-1"   # mumbai
  }
}
