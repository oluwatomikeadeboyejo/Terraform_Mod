resource "aws_subnet" "subnets" {
  for_each = { for s in var.subnets : s.name => s } 

  vpc_id     = var.vpc_output
  cidr_block        = each.value.cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch            
  availability_zone = each.value.availability_zone
  tags = merge(var.required_tags, {"Name"=each.value.name})
}


