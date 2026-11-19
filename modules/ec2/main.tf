resource "aws_instance" "myec2" {
  ami           = var.ec2_config.ami_id
  instance_type = var.ec2_config.instance_type
  subnet_id     = var.ec2_config.subnet_id
  count         = var.ec2_config.ec2_count
  volume        = var.ec2_config.volume

  tags = {
    name = "${env}-ec2-${count.index}"
    env  = var.ec2_config.env
  }
}
