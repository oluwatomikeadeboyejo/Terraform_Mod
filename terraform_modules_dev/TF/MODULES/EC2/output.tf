output "application_load_balancer" {
  description = "ID of application load balancer"
  value       = aws_lb_target_group.TG.arn
}



