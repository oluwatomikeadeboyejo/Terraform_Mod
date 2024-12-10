variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  default = "us-east-1"
}

################################################ EC2 Variables ###########################

variable "key_name"{
  default = "new_key_1"
} 

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "ami" {
  default = "ami-05951e2dbb17546c6"
}


variable "instance_type" {
  default = "t2.micro"
}


#create a map called vc2 details 
variable "EC2_DETAILS" {
  type=map(string)
  default={
    volume_size=30
    volume_type="gp2"
    delete_on_termination=false
    encrypted=false
  }
}

variable "bootstrap"{
type = string
description = "path to bootstrap script"
default = "/scripts/bootstrap.tpl"
}

variable "instance_name"{
  default = "Server-EC2"
} 



################### RDS VARIABLES ####################

variable "identifier" {
  type    = string
  default = "teraform-module"
}

variable "snapshot_identifier" {
  type    = string
  default = "arn:aws:rds:us-east-1:577701061234:snapshot:wordpressdbXXXXsnap"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0.28"
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "parameter_group_name" {
  type    = string
  default = "default.mysql8.0"
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "storage_type" {
  type    = string
  default = "gp2"
}



################### VPC VARIABLES ####################
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "Name" {
  type    = string
  default = "Modules-Terraform-VPC"
}


######## Required Tags 


variable "environment" {
  default = "dev"
}


variable "Session"{
default = "XXXX"

} 

variable "Subsystem"{
default = "XXXX"
} 

variable "Backup"{
  default = "yes"
} 

variable "Organization"{
  default = "XXXX"
} 

################### Subnet VARIABLES ####################

variable "subnets" {
  description = "Details of each subnet to be created in us-east-1b and us-east-1c"
  type        = list(object({ # an object is a data structure that allows you to define multiple named attributes of potentially different types. 
    cidr_block        = string
    availability_zone = string # tells terraform the type of values to expect for each object.
    name              = string
  }))
  default     = [
    { cidr_block = "10.0.0.0/23",  availability_zone = "us-east-1b", name = "Public-TF -us-east-1b" },
    { cidr_block = "10.0.11.0/24", availability_zone = "us-east-1b", name = "XXXX-Web-TF-Private-us-east-1b" },
    { cidr_block = "10.0.12.0/22",  availability_zone = "us-east-1b", name = "XXXX-RDS-TF-Private-us-east-1b" },
    { cidr_block = "10.0.8.0/26",  availability_zone = "us-east-1b", name = "RDS-Java-TF-Private-us-east-1b" },
    { cidr_block = "10.0.9.0/26",  availability_zone = "us-east-1b", name = "Java-Web-TF-Private-us-east-1b" },
    { cidr_block = "10.0.2.0/24",  availability_zone = "us-east-1b", name = "Migration-RDS-TF-Private-us-east-1b" },
    { cidr_block = "10.0.6.0/24",  availability_zone = "us-east-1b", name = "Clone-RDS-TF-Private-us-east-1b" },
# Avaliabity Zone east 1c
    { cidr_block = "10.0.16.0/23",  availability_zone = "us-east-1c", name = "Public-TF -us-east-1c" },
    { cidr_block = "10.0.19.0/24",  availability_zone = "us-east-1c", name = "XXXX-Web-TF-Private-us-east-1c"},
    { cidr_block = "10.0.20.0/22",  availability_zone = "us-east-1c", name = "XXXX-RDS-TF-Private-us-east-1c"},
    { cidr_block = "10.0.28.0/26",  availability_zone = "us-east-1c", name = "Java-Web-TF-Private-us-east-1c"},
    { cidr_block = "10.0.30.0/26",  availability_zone = "us-east-1c", name = "Java-RDS-TF-Private-us-east-1c"}
  ]
}


variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}


###################### Security Groups


variable "name_prefix" {
  description = "Prefix for the security group name"
  default     = "new_security"  // optional default value
}



variable "stack_controls" {
  type = map (string)
  default = {
    CORE_INFO = "Y"
    EC2-BASE= "Y"
    RDS-BASE = "Y"
    VPC-BASE = "Y"
    SUBNET-BASE = "Y"
    SECURITY-GROUP-BASE = "Y"
  }
}



########### Security group variables #######

variable "security_group_name" {
  description = "Name of the security group for servers"
  default     = "Server-Module"
}

variable "security_group_description" {
  description = "Description of the security group for servers"
  default     = "Security Group for Servers"
}

variable "inbound_ports" {
  default = [
    {
      port            = 443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = null
    },
    {
      port            = 80
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = null
    },
    {
      port            = 22
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = null
    }
  ]
}

variable "outbound_ports" {
  default = [
    {
      port            = 443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = null
    },
    {
      port            = 80
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = null
    },
    {
      port            = 22
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = null
    }
  ]
}



# ############### Auto Scaling ################

variable "name" {
  description = "The name of the autoscaling group"
  type        = string
  default     = "auto-scaling"
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "The desired capacity of the autoscaling group"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  default     = 1
}

variable "health_check_grace_period" {
  description = "The time in seconds that the system should wait before checking the instance's health"
  type        = number
  default     = 120
}

variable "health_check_type" {
  description = "The type of health check. Either 'EC2' or 'ELB'"
  type        = string
  default     = "EC2"
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another can begin"
  type        = number
  default     = 30
}

variable "force_delete" {
  description = "Allows deletion of the autoscaling group without waiting for all instances to terminate"
  type        = bool
  default     = true
}



variable "launch_template_version" {
  description = "The version of the launch template"
  type        = string
  default     = "$Latest"
}


################################ Launch Template 

variable "name_prefix_launch_template" {
  description = "Prefix for the name of the resource"
  type        = string
  default     = "XXXX-template-terraform"
}

variable "description" {
  description = "Description for the resource"
  type        = string
  default     = "XXXX App Bootstrap"
}

variable "XXXX_key_name"{
  default = "stackkp"
} 

variable "block_device_mappings" {
  description = "List of block device mappings"
  type = list(object({
    device_name           = string
    volume_size           = number
    volume_type           = string
    delete_on_termination = bool
  }))
  default = [
    {
      device_name           = "/dev/sdb"
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    },
    {
      device_name           = "/dev/sdc"
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    },
    {
      device_name           = "/dev/sdd"
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    },
    {
      device_name           = "/dev/sde"
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    }
  ]
}


#### target Group

variable "XXXX_LB_TG" {
  description = "Name for the Load Balancer Target Group"
  type        = string
  default     = "XXXX-App-LB-MODULES"
}



variable "target_group_port" {
  description = "The port for the target group."
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "The protocol for the target group (e.g., HTTP, HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "health_check_enabled" {
  description = "Indicates whether health checking is enabled."
  type        = bool
  default     = true
}

variable "health_check_interval" {
  description = "The duration, in seconds, between health checks."
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "The path for the health check."
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "The port for the health check."
  type        = string
  default     = "80"
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, to wait for a health check response."
  type        = number
  default     = 10
}

variable "healthy_threshold" {
  description = "The number of consecutive successful health checks required before declaring an EC2 instance healthy."
  type        = number
  default     = 5
}

variable "unhealthy_threshold" {
  description = "The number of consecutive failed health checks required before declaring an EC2 instance unhealthy."
  type        = number
  default     = 4
}

variable "matcher" {
  description = "The HTTP response codes to consider when checking for a successful response from a target."
  type        = string
  default     = "200-400"
}


# Load Balanacer Name
variable "XXXX_Frontend_LB" {
  default = "XXXX-App-LB-Module"
}


# Internet Gateway 
variable "internet_gateway" {
  type    = string
  default = "internet_gateway_terraform-modules"
}