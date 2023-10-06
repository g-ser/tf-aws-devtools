resource "aws_codepipeline" "codepipeline_create_resources" {

  name     = var.codepipeline_create_resources_name
  role_arn = aws_iam_role.codepipeline-role.arn

  # S3 bucket where CodePipeline will store its artifacts
  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.s3-bucket-backend.bucket
  }
  # stage to retrive code from codecommit
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["infra_code"]
      configuration = {
        RepositoryName       = aws_codecommit_repository.infra-codecommit-repo.repository_name
        BranchName           = "main"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }
  # call codebuild to run terraform plan
  stage {
    name = "Plan"
    action {
      name            = "Build"
      category        = "Test"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["infra_code"]
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project_plan_stage.name
      }
    }
  }
  # call codebuild to run terraform apply
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["infra_code"]
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project_apply_stage.name
      }
    }
  }
}

resource "aws_codepipeline" "codepipeline_delete_resources" {

  name     = var.codepipeline_delete_resources_name
  role_arn = aws_iam_role.codepipeline-role.arn

  # S3 bucket where CodePipeline will store its artifacts
  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.s3-bucket-backend.bucket
  }
  stage {
    name = "Source"
    action {
      name             = "ApplicationSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      run_order        = 1
      version          = "1"
      configuration = {
        "ConnectionArn": "arn:aws:codestar-connections:region:account-id:connection/connection-id"
      }
    }
  }
  stage {
    name = "ApprovalDestroy"
    action {
      name            = "Build"
      category        = "Test"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      run_order       = 2
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project_plan_destroy_stage.name
      }
    }
  }

  # call codebuild to run terraform destroy
  stage {
    name = "TerraformDestroy"
    action {
      name            = "Destroy"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      run_order       = 3
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project_destroy_stage.name
      }
    }
  }
}