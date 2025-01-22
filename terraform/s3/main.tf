terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_files  = ["C:/Users/qyang/.aws/credentials"]
  profile                   = "deployer"
}

resource "aws_s3_bucket" "example" {
  bucket = "qijun-tf-test-bucket"
  force_destroy = true

  tags = {
    SERVICEID   = "ts01472"
    ENVIRONMENT = "qa"
    FUNCTION    = "app"
  }
}