terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

# Create an S3 bucket for storing the tf state file

resource "random_id" "s3_bucket_name_suffix" {
  byte_length = 8
}

locals {
  bucket_name = "${var.s3_bucket_name_prefix}-${random_id.s3_bucket_name_suffix.hex}"
}

resource "aws_s3_bucket" "s3-bucket-backend" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "bucket-ownership" {
  bucket = aws_s3_bucket.s3-bucket-backend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3-bucket-backend-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket-ownership]

  bucket = aws_s3_bucket.s3-bucket-backend.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3-bucket-backend-versioning" {
  bucket = aws_s3_bucket.s3-bucket-backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# create an empty folder in S3 bucket to store the backend state file

resource "aws_s3_object" "terraform_folder" {
  bucket = aws_s3_bucket.s3-bucket-backend.id
  key    = "terraform_backend/"
}

# Create the codecommit repository to store the terraform code

resource "aws_codecommit_repository" "infra-codecommit-repo" {
  repository_name = var.codecommit_repository_name
  description     = "CodeCommit Repository to store VPC infra terraform codes."
}

