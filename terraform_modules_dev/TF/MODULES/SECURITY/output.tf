output "security_group" {
   description = "ID of the security group"
   value       = aws_security_group.new_security.id
}

