variable "region" {}
variable "env" {}
variable "app_name" {}
variable "tags" {
  type = map(any)
}
variable "vpc" {}
variable "subnets" {
  type = list(any)
}
variable "image_tag" {}
variable "source_path" {
  description = "source path for project"
  default     = "./"
}
variable "ecr" {}