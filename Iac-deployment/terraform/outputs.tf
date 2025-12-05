output "alb_dns_name" {
  description = "Public ALB DNS name"
  value       = aws_lb.app_alb.dns_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  value = [for s in aws_subnet.private : s.id]
}
