output "bucket_name" {
  description = "get the private ip of the nat gateway"
  value       = aws_s3_bucket.s3-bucket-backend.bucket
}

output "git_ssh_url" {
  description = "The URL to use for cloning the repository over SSH"
  value = aws_codecommit_repository.infra-codecommit-repo.clone_url_ssh
}