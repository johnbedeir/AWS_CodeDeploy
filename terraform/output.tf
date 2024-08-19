output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ubuntu-instance.public_ip
}

output "load_balancer_dns" {
  value = aws_elb.web_lb.dns_name
}