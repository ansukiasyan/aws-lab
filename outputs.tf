output "public_ip" {
  value       = aws_instance.ubuntu.public_ip
  description = "Public IP address of the ubuntu web server"
}