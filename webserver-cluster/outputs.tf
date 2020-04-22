output "lb_dns_name" {
  value       = aws_lb.ubuntu.dns_name
  description = "The domain name of the load balancer"
}