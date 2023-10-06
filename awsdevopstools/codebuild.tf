# This files creates four CodeBuild projects:
# the first one is for running the "terraform plan" command
# the second is for running the "terraform apply" command
# the third is for running the "terraform plan -destroy" command
# the fourth is for running the "terraform destroy" command

# create an execution plan

resource "aws_codebuild_project" "codebuild_project_plan_stage" {
  name         = var.codebuild_plan_project_name
  description  = "Terraform Planning Stage"
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "hashicorp/terraform:latest"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspec/plan-buildspec.yml")
  }
}

# provision the infrastructure

resource "aws_codebuild_project" "codebuild_project_apply_stage" {
  name         = var.codebuild_apply_project_name
  description  = "Terraform Apply Stage"
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "hashicorp/terraform:latest"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspec/apply-buildspec.yml")
  }
}

# create a speculative destroy plan, to see what the effect of destroying would be

resource "aws_codebuild_project" "codebuild_project_plan_destroy_stage" {
  name         = var.codebuild_plan_destroy_project_name
  description  = "Terraform Plan Destroy Stage"
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "hashicorp/terraform:latest"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspec/plan-destroy-buildspec.yml")
  }
}

# Destroy the infrastructure 

resource "aws_codebuild_project" "codebuild_project_destroy_stage" {
  name         = var.codebuild_destroy_project_name
  description  = "Terraform Destroy Stage"
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "hashicorp/terraform:latest"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspec/destroy-buildspec.yml")
  }
}