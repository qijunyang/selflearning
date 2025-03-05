terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  ## specify store the state file in s3
  backend "s3" {
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["C:/Users/qyang/.aws/credentials"]
  profile                  = "deployer"
}

locals {
  cluster_name   = "${var.application_name}-cluster-${var.environment}"
  container_name = "${var.application_name}-container-${var.environment}"
  service_name   = "${var.application_name}-service-${var.environment}"
}

data "aws_route53_zone" "zone" {
  zone_id = var.zone_id
}

data "aws_caller_identity" "current" {}

data "aws_subnets" "private" {
  #   filter {
  #     name   = "tag:Name"
  #     values = ["*private"]
  #   }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_security_groups" "private_web" {
  #   filter {
  #     name   = "group-name"
  #     values = ["private_web", "private_app", "private_db", "public"]
  #   }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

module "logs" {
  source           = "./modules/logs"
  application_name = var.application_name
  environment      = var.environment
  tags             = var.tags
}

# module "cloudfront_s3" {
#   source           = "./modules/cloudfront_s3"
#   application_name = var.application_name
#   environment      = var.environment
#   tags             = var.tags
# }

# module "record" {
#   source                 = "./modules/record"
#   zone_id                = var.zone_id
#   environment            = var.environment
#   record_name            = var.record_name
#   cloudfront_domain_name = module.cloudfront_s3.cloudfront_domain_name
#   cloudfront_zone_id     = module.cloudfront_s3.cloudfront_zone_id
# }