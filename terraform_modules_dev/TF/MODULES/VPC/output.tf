output "vpc_output" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}
