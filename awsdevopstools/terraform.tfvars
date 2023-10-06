# credentials for connecting to AWS
credentials_location = "~/.aws/credentials"

# AWS Region
aws_region = "eu-north-1"

# The name of the CodeCommit repo in AWS
codecommit_repository_name = "infra-repo"

# The first part of the name of the S3 bucket
s3_bucket_name_prefix = "infra-backend"


codebuild_role_name = "infra-codebuild-role"

codepipeline_role_name = "infra-codepipeline-role"

codebuild_policy_name = "infra-codebuild-policy"

codepipeline_policy_name = "infra-codepipeline-policy"

codebuild_plan_project_name = "infra-codebuild-project-plan"

codebuild_apply_project_name = "infra-codebuild-project-apply"

codepipeline_create_resources_name = "infra-create-codepipeline"

codepipeline_delete_resources_name = "infra-delete-codepipeline"

codebuild_destroy_project_name = "infra-codebuild-project-destroy"

codebuild_plan_destroy_project_name = "infra-codebuild-project-plan-destroy"