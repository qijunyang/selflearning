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

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.example.id
  key    = "index.html"
  source = "${path.module}/index.html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("${path.module}/index.html")
}