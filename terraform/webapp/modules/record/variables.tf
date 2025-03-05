variable "record_name" {
  type = string
}

# for creating tag only
variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "stg", "qa", "uat", "prd", "dr"], var.environment)
    error_message = "Allowed values for environment are \"dev\", \"qa\", \"stg\", \"uat\", \"prd\", \"dr\"."
  }
}

variable "zone_id" {
  type = string
}

variable "cloudfront_domain_name" {
  type = string
}

variable "cloudfront_zone_id" {
  type = string
}
