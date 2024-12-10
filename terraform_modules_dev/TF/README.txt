# Terraform Module: [TF]

This project serves as a baseline for building scalable and secure infrastructure within AWS. It is a collection of Terraform modules that set up an AWS infrastructure through Infrastructure as Code (IaC).


Prerequisites
Terraform installed
AWS CLI installed and configured
A variables.tf file set up with necessary input variables

## Installation

1. Install Terraform.
2. Configure your AWS credentials.
3. Run `terraform init` and `terraform apply`.

---

## AWS Components

- CORE_INFO
- EC2 Module
- RDS Module
- S3 Module
- VPC Module
- Security Group Module

---

### CORE_INFO

**Responsibility:**  
This module handles the tagging of all resources. It facilitates easy tracking and management.

**Features:**
- Resource tagging

---

### VPC Module

**Responsibility:**  
This module sets up a VPC (Virtual Private Cloud) for isolating resources within the AWS cloud.

**Features:**
none

---

### EC2 Module

**Responsibility:**  
This module manages EC2 (Elastic Compute Cloud) instances. Responsible for creating, configuring, and managing Amazon EC2 instances.

**Features:**
- Key pairs

---

### RDS Module

**Responsibility:**  
Handles setup and configuration of RDS (Relational Database Service) instances.

**Features:**
- Database creation
- Automated backups

---

### S3 Module

**Responsibility:**  
This module manages S3 (Simple Storage Service) buckets.

**Features:**
none

---

### Security Group Module

**Responsibility:**  
Manages security groups to control inbound and outbound traffic.

**Features:**
- Inbound rules
- Outbound rules

---

Usage
After cloning the repository and setting up your variables.tf, execute terraform init followed by terraform apply.
---

## Variables

Define all required variables in your `variables.tf` file.
---


## Changing Variable Values

### Using `terraform.tfvars` or `.auto.tfvars` Files

You can define a file named `terraform.tfvars` or any `.auto.tfvars` file in the same directory where your main Terraform configuration files are located. In this file, you can specify new values for variables. For example:

```hcl
ami = "ami-12345678"
OwnerEmail = "owner@example.com"
```

If the file is named `terraform.tfvars`, Terraform will automatically load it. If it's named differently, you would have to specify it explicitly using the `-var-file` flag when running `terraform apply` or `terraform plan`.

### Using `-var` Flag at Command Line

You can override variable values when running `terraform apply` or `terraform plan` by specifying the `-var` flag. For example:

```bash
terraform apply -var "ami=ami-12345678" -var "OwnerEmail=owner@example.com"
```

---
