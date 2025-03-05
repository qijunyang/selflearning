variable "application_name" {
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

variable "tags" {
  type        = map(any)
  description = "Specify tags which should be assigned to AWS Resources."
}