# Retrieve at runtime the id of the AWS account 

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

# Create a policy document that defines the permissions below:
# 1. CloudWatch permissions so that CodePipeline can be integrated with CloudWatch events
# 2. Ability to store the artifact in S3 inside the specified bucket
# 3. Ability to run CodeBuild projects
# 4. Ability to fetch the code from CodeCommit

data "aws_iam_policy_document" "codepipeline-policy-document" {
  statement {
    actions   = ["cloudwatch:*"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = ["codebuild:*"]
    resources = [
      "arn:aws:codebuild:${var.aws_region}:${local.account_id}:project/${var.codebuild_plan_project_name}",
      "arn:aws:codebuild:${var.aws_region}:${local.account_id}:project/${var.codebuild_apply_project_name}"
    ]
    effect = "Allow"
  }
  statement {
    actions   = ["codecommit:*"]
    resources = [aws_codecommit_repository.infra-codecommit-repo.arn]
    effect    = "Allow"
  }

  statement {
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.s3-bucket-backend.arn}/*"]
    effect    = "Allow"
  }
}

# Create an IAM custom policy based on the above policy document 

resource "aws_iam_policy" "codepipeline-policy" {
  name   = var.codepipeline_policy_name
  path   = "/"
  policy = data.aws_iam_policy_document.codepipeline-policy-document.json
}

# Create an IAM role and specify via assume_role_policy the entities that are
# allowed to assume the role

resource "aws_iam_role" "codepipeline-role" {
  name = var.codepipeline_role_name

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "codepipeline.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

# Attach the IAM policy created above to the IAM role which is created above

resource "aws_iam_role_policy_attachment" "codepipeline-policy-attachment" {
  policy_arn = aws_iam_policy.codepipeline-policy.arn
  role       = aws_iam_role.codepipeline-role.id
}