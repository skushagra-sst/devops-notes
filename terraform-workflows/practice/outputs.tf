# Output variables

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "web_instance_id" {
  description = "ID of the web EC2 instance"
  value       = aws_instance.web.id
}

output "web_instance_public_ip" {
  description = "Public IP address of the web instance"
  value       = aws_instance.web.public_ip
}

output "web_instance_private_ip" {
  description = "Private IP address of the web instance"
  value       = aws_instance.web.private_ip
}

output "elastic_ip" {
  description = "Elastic IP address"
  value       = aws_eip.web.public_ip
}

output "db_instance_private_ip" {
  description = "Private IP address of the database instance"
  value       = aws_instance.db.private_ip
}
