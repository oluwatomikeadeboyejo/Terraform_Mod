locals {

  Server_Prefix = ""
}
 
resource "aws_key_pair" "Stack_KP_rename" {
  key_name   = var.key_name
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

####### Instance 
 resource "aws_instance" "Server" {
 subnet_id     = var.subnet
 ami           = var.ami
 instance_type          = var.instance_type
 vpc_security_group_ids = [var.security_group_output]
 user_data = base64encode(templatefile("${path.module}${var.bootstrap}", var.user_data_settings))
 key_name =aws_key_pair.Stack_KP_rename.id

root_block_device {
   volume_type           = var.EC2_DETAILS["volume_type"]    
   volume_size           = var.EC2_DETAILS["volume_size"]
   delete_on_termination = var.EC2_DETAILS["delete_on_termination"]
   encrypted = var.EC2_DETAILS["encrypted"]
 }

tags = merge(var.required_tags, {"Name"=var.instance_name})

 }


# Launch Template XXXX
resource "aws_launch_template" "Template" {
  name_prefix            = var.name_prefix_launch_template
  description            = var.description
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.Stack_KP_rename.key_name
  vpc_security_group_ids = [var.security_group_output]


   user_data = base64encode(templatefile("${path.module}${var.bootstrap}", var.user_data_settings))

    dynamic "block_device_mappings" {
    for_each = var.block_device_mappings

    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
        delete_on_termination = block_device_mappings.value.delete_on_termination
      }
    }
  }
}



# AutoScaling Group Configuration
resource "aws_autoscaling_group" "AutoScaling" {
  name                      = var.name
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  default_cooldown          = var.default_cooldown
  force_delete              = var.force_delete
  vpc_zone_identifier       = var.vpc_zone_identifier
  target_group_arns         = [aws_lb_target_group.TG.arn]

  # Launch template reference for the EC2 instances to be launched
  launch_template {
    id      = aws_launch_template.Template.id
    version = var.launch_template_version
  }

}

# Load Balancer Target Group 
resource "aws_lb_target_group" "TG" {
  name        = var.LB_TG
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.target_vpc_id
  health_check {
    enabled             = var.health_check_enabled
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.health_check_port
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    matcher             = var.matcher
  }

}



