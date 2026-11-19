resource "aws_instance" "myec2" {
  count                  = var.ec2_config.ec2_count
  ami                    = var.ec2_config.ami_id
  instance_type          = var.ec2_config.instance_type
  subnet_id              = var.ec2_config.subnet_id
  vpc_security_group_ids = var.ec2_config.security_group_ids
  key_name               = var.ec2_config.key_name

  root_block_device {
    volume_size = var.ec2_config.volume
    encrypted   = true
  }

  tags = merge(var.tags, {
    Name = "${var.ec2_config.env}-ec2-${count.index}"
    env  = var.ec2_config.env
  })
}

output "instance_ids" {
  description = "EC2 instance ids"
  value       = aws_instance.myec2[*].id
}

output "private_ips" {
  description = "EC2 private IPs"
  value       = aws_instance.myec2[*].private_ip
}
