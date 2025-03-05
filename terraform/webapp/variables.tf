variable "aws_region" {
  type    = string
  default = "us-east-1"

  validation {
    condition     = contains(["us-east-1", "us-west-2"], var.aws_region)
    error_message = "Allowed values for aws_region are \"us-east-1\", \"us-west-2\"."
  }
}

variable "application_name" {
  type    = string
  default = "webapp"
}

variable "record_name" {
  type    = string
  default = "webapp"
}

# for creating tag only
variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "stg", "qa", "uat", "prd", "dr"], var.environment)
    error_message = "Allowed values for environment are \"dev\", \"qa\", \"stg\", \"uat\", \"prd\", \"dr\"."
  }
}

variable "tags" {
  type        = map(any)
  description = "Specify tags which should be assigned to AWS Resources."
  default = {
    MANAGED = "terraform"
  }
}

variable "vpc_id" {
  type    = string
  default = "vpc-0cbcb4541992f171b"
}

variable "container_image" {
  type    = string
  default = "xxxx.dkr.ecr.us-east-1.amazonaws.com/webapp"
}

variable "container_image_version" {
  type    = string
  default = "1.1.0"
}

variable "task_definition_cpu_size" {
  type    = number
  default = 4
}

variable "task_definition_memory_size" {
  type    = number
  default = 2048
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "zone_id" {
  type    = string
  default = "Z09650071ANRZWB0A249H"
}

variable "memory_utilization_high_threshold" {
  type    = number
  default = 80
}

variable "memory_utilization_low_threshold" {
  type    = number
  default = 30
}

variable "cpu_utilization_high_threshold" {
  type    = number
  default = 80
}

variable "cpu_utilization_low_threshold" {
  type    = number
  default = 30
}

variable "container_port" {
  type    = number
  default = 8080
}