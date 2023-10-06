variable "aws_region" {
  type        = string
  description = "The AWS region where the infrastructure will be provisioned"
}

variable "codecommit_repository_name" {
  type        = string
  description = "The name of the CodeCommit repo in AWS"
}

variable "s3_bucket_name_prefix" {
  type        = string
  description = "The name of the S3 bucket where the terraform's state file is going to be stored"
}

variable "credentials_location" {
  description = "The location in your local machine of the aws_access_key_id and aws_secret_access_key"
  type        = string
}

variable "codebuild_role_name" {
  type        = string
  description = "The name of the codebuild role"
}

variable "codepipeline_role_name" {
  type        = string
  description = "The name of the codepipeline role"
}

variable "codebuild_policy_name" {
  type        = string
  description = "The name of the codebuild policy"
}

variable "codepipeline_policy_name" {
  type        = string
  description = "The name of the codepipeline policy"
}

variable "codebuild_plan_project_name" {
  type        = string
  description = "The name of the codebuild plan project"
}

variable "codebuild_apply_project_name" {
  type        = string
  description = "The name of the codebuild apply project"
}

variable "codebuild_destroy_project_name" {
  type        = string
  description = "The name of the codebuild destroy project"
}

variable "codepipeline_create_resources_name" {
  type        = string
  description = "The name of the create resources codepipeline instance"
}

variable "codepipeline_delete_resources_name" {
  type        = string
  description = "The name of the delete resources codepipeline instance"
}

variable "codebuild_plan_destroy_project_name" {
  type        = string
  description = "The name of the codebuild plan destroy project"
}

