output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_ip_address" {
  value = aws_instance.api_instance.public_ip_address
}
