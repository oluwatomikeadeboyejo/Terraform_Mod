### Keys ###
variable "key_name" {}

variable "PATH_TO_PUBLIC_KEY" {}


# EC2 variables 

variable "subnet" {}

variable "ami" {}

variable "instance_type" {}

variable "security_group_output" {}

variable "bootstrap" {}

variable "EC2_DETAILS" {}

variable "required_tags" {}

variable "instance_name"{} 

variable "user_data_settings" {}

# Autosclaing groups
variable "name"{}

variable "max_size"{}
variable "desired_capacity"{}
variable "min_size"{}
variable "health_check_grace_period"{}
variable "health_check_type"{}
variable "default_cooldown"{} 
variable "force_delete"{} 
variable "vpc_zone_identifier"{} 
variable "launch_template_version"{}


#Launch template

variable "name_prefix_launch_template" {}

variable "description" {}

variable vpc_security_group_ids {}

variable "block_device_mappings" {}




####Target

variable "LB_TG" {}

variable "target_group_port" {}

variable "target_group_protocol" {}

variable "target_vpc_id" {}

variable "health_check_enabled" {}

variable "health_check_interval" {}

variable "health_check_path" {}

variable "health_check_port" {}

variable "health_check_timeout" {}

variable "healthy_threshold" {}

variable "unhealthy_threshold" {}

variable "matcher" {}
