output "instance_public_ip" {
  description = "The public IP address of the deployed EC2 instance"
  value       = aws_instance.example_server.public_ip
}

output "instance_id" {
  description = "The ID of the deployed EC2 instance"
  value       = aws_instance.example_server.id
}
