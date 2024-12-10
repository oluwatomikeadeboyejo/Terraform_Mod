module "CORE_INFO" {
  source = "./MODULES/CORE_INFO" 
  
  required_tags = {  
    OwnerEmail    = var.OwnerEmail,
    environment   = var.environment,
    Session       = var.Session,
    Subsystem     = var.Subsystem,
    Backup        = var.Backup,
    Organization  = var.Organization
  }
}

module "EC2-BASE" {
  source = "./MODULES/EC2"


  count = var.stack_controls["EC2-BASE"] == "Y" ? 1 : 0
  ami                   = var.ami
  instance_type         = var.instance_type
  subnet                = local.XXXX_public_us_east_1b 
  EC2_DETAILS           = var.EC2_DETAILS
  required_tags         = module.CORE_INFO.all_resource_tags
  key_name              = var.key_name
  PATH_TO_PUBLIC_KEY    = var.PATH_TO_PUBLIC_KEY
  instance_name         = var.instance_name 
  security_group_output = module.SECURITY-GROUP-BASE[0].security_group
 

  

# Launch Template
 name_prefix_launch_template  = var.name_prefix_launch_template
 description                  = var.description
 user_data_settings           = local.user_data_settings
 bootstrap                    = var.bootstrap
 block_device_mappings        = var.block_device_mappings
 vpc_security_group_ids       = module.SECURITY-GROUP-BASE[0].security_group

 

# Load Balancer
XXXX_LB_TG              = var.XXXX_LB_TG
target_group_port        = var.target_group_port
target_group_protocol    = var.target_group_protocol
target_vpc_id            = module.VPC-BASE[0].vpc_output 
health_check_enabled     = var.health_check_enabled
health_check_interval    = var.health_check_interval
health_check_path        = var.health_check_path
health_check_port        = var.health_check_port
health_check_timeout     = var.health_check_timeout
healthy_threshold        = var.healthy_threshold
unhealthy_threshold      = var.unhealthy_threshold
matcher                  = var.matcher



# Autoscaling group
  name                      = var.name
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  default_cooldown          = var.default_cooldown
  force_delete              = var.force_delete
  vpc_zone_identifier       = local.autosclaing
  launch_template_version   = var.launch_template_version

}


module "RDS-BASE" {
  source = "./MODULES/RDS"
  
  count = var.stack_controls["RDS-BASE"] == "Y" ? 1 : 0
  identifier              = var.identifier
  snapshot_identifier     = var.snapshot_identifier
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  engine                  = var.engine
  engine_version          = var.engine_version
  multi_az                = var.multi_az
  parameter_group_name    = var.parameter_group_name
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  storage_type            = var.storage_type
  required_tags           = module.CORE_INFO.all_resource_tags
  rds_subnet              = local.rds_group
  vpc_security_group_ids = module.SECURITY-GROUP-BASE[0].security_group
}


module "VPC-BASE" {
  source = "./MODULES/VPC"

  count = var.stack_controls["VPC-BASE"] == "Y" ? 1 : 0
  vpc_cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  Name                 = var.Name
}


module "SUBNET-BASE" {
  source = "./MODULES/SUBNET"

  count = var.stack_controls["SUBNET-BASE"] == "Y" ? 1 : 0
  vpc_output              = module.VPC-BASE[0].vpc_output   
  map_public_ip_on_launch = var.map_public_ip_on_launch
  required_tags           = module.CORE_INFO.all_resource_tags
  subnets                 = var.subnets

}


module "SECURITY-GROUP-BASE" {
  source = "./MODULES/SECURITY"

  count = var.stack_controls["SUBNET-BASE"] == "Y" ? 1 : 0
  vpc_output            = module.VPC-BASE[0].vpc_output
  security_group_name   = var.security_group_name
  security_group_description = var.security_group_description
  inbound_ports         = var.inbound_ports 
  outbound_ports        = var.outbound_ports

}

# Application Load Balancer 
resource "aws_lb" "XXXX_Application_LB" {
  name                       = var.XXXX_Frontend_LB
  internal                   = false
  enable_http2               = true
  load_balancer_type         = "application"
  security_groups            = [module.SECURITY-GROUP-BASE[0].security_group]
  subnets                    = [local.XXXX_public_us_east_1b,local.XXXX_web_TF_us_east_1c]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection = false
}

# Load Balancer Listener Attached Application Load Balancer
resource "aws_lb_listener" "XXXX_front_end" {
  load_balancer_arn = aws_lb.XXXXX_Application_LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = module.EC2-BASE[0].application_load_balancer
  }
}

# EFS MOUNT 
resource "aws_efs_file_system" "XXXX_EFS" {
  creation_token   = "my-unique-tokenpart2"
  encrypted        = true # Enable encryption
  kms_key_id       = "arn:aws:kms:us-east-1:#####:key/bd43d581-0819-4a50-a599-eca363c73a55"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}


resource "aws_efs_mount_target" "XXXX_EFS_Mount1" {
  file_system_id  = aws_efs_file_system.XXXX_EFS.id
  subnet_id       = local.XXXX_web_TF_us_east_1c
  security_groups = [module.SECURITY-GROUP-BASE[0].security_group]
}


# SECRETS MANAGER
data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "XXXX_secrets"
}


resource "aws_internet_gateway" "igw" {
  vpc_id = module.VPC-BASE[0].vpc_output 
  tags = {
    Name = var.internet_gateway
  }
}