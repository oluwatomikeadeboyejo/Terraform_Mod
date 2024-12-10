resource "aws_db_instance" "clixx_db" {
  identifier          = var.identifier
  snapshot_identifier = var.snapshot_identifier
  instance_class      = var.instance_class
  allocated_storage   = var.allocated_storage
  engine              = var.engine
  engine_version      = var.engine_version
  multi_az            = var.multi_az
  parameter_group_name    = var.parameter_group_name
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  storage_type            = var.storage_type
  vpc_security_group_ids   = [var.vpc_security_group_ids]

   db_subnet_group_name = aws_db_subnet_group.my_rds_subnet_group.name

}

resource "aws_db_subnet_group" "my_rds_subnet_group" {
  name       = "my-subnet-group-tf"
  subnet_ids = var.rds_subnet

  tags = merge(var.required_tags, {"Name"="rds-tf-subnet-group "}) 
}