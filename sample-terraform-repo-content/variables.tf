variable "region" {
  description = "The AWS region where the infrastructure will be provisioned"
  type        = string
}

variable "bucket_name" {
  description = "The bucket which is going to be used as backend from terraform for hosting the state file"
  type = string
}