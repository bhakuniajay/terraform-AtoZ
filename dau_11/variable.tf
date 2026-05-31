variable "project_name"{
  default = "Project ALPHA Resource"

}
variable "default_tags" {
  default = {
    company = "TechCorp"
    managed_by="terraform"
  }
}

variable "environment_tags" {
  default = {
    environment = "production"
    cost_center ="cc-123"
  }
}

variable "bucket_name" {
  default = "PRoject with C"
}
variable "environment" {
  type = string
}
variable "allowed_ports" {
  default = "80,443,8080"
}
variable "instance_sizes" {
  default = {
    dev = "t2.micro"
    staging ="t3.small"
    prod = "t2.large"
  }

}

variable "instance_type" {
  default = "t2.micro"
  validation {
    condition = length(var.instance_type) >=2 && length(var.instance_type)<=16
    error_message = "Instance type is more than or less than 0 or 16" 
  }
  validation {
    condition = can(regex("^t[2-3]\\.",var.instance_type))
    error_message = "Instance type must be T2 or T3 "
  }
  
}

variable "backup_name" {
  default = "daily_backup"
  validation {
    condition = endswith(var.backup_name, "_backup")
    error_message = "Backup must ends with '_backup' "
  }
}

variable  "credentials"{
  default = "zyz123"
  sensitive = true
}
variable "user_loations" {
  default = ["us-west-1","us-west-2","us-east-1"]
}

variable "default_location" {
  default = ["us-west-1"]
  
}
variable "monthly_costs" {
  default = [-50,100,75,200] #-50 is credit
}
