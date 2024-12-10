resource "aws_security_group" "new_security" {
  name_prefix = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_output

  dynamic "ingress" {
    for_each = var.inbound_ports

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol


      cidr_blocks     = ingress.value.cidr_blocks != null ? ingress.value.cidr_blocks : []

      security_groups = ingress.value.security_groups != null ? ingress.value.security_groups : []
    }
  }

  dynamic "egress" {
    for_each = var.outbound_ports

    content {
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.protocol


      cidr_blocks     = egress.value.cidr_blocks != null ? egress.value.cidr_blocks : []
      

      security_groups = egress.value.security_groups != null ? egress.value.security_groups : []
    }
  }
}



 