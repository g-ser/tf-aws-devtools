# Create the policy document which includes allow effects for 
# accessing the specified S3 bucket and its content 
# as well as the ability to store build logs in CloudWatch Logs


data "aws_iam_policy_document" "codebuild-policy-document" {
  statement {
    actions   = ["logs:*"]
    resources = ["arn:aws:logs:*:*:*"]
    effect    = "Allow"
  }
  statement {
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.s3-bucket-backend.arn}/*",
      "${aws_s3_bucket.s3-bucket-backend.arn}"
    ]
    effect = "Allow"
  }
}

# Create an IAM custom policy based on the above policy document 

resource "aws_iam_policy" "codebuild-policy" {
  name   = var.codebuild_policy_name
  path   = "/"
  policy = data.aws_iam_policy_document.codebuild-policy-document.json
}

# Create an IAM role and specify via assume_role_policy the entities that are
# allowed to assume the role

resource "aws_iam_role" "codebuild-role" {
  name = var.codebuild_role_name
  # Policy that grants an entity permission to assume the role
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

# Attach the IAM policy created above to the IAM role which is created above

resource "aws_iam_role_policy_attachment" "codebuild-policy-attachment1" {
  policy_arn = aws_iam_policy.codebuild-policy.arn
  role       = aws_iam_role.codebuild-role.id
}

# Attach the IAM built-in policy for accessing VPC to the IAM role which is created above 

resource "aws_iam_role_policy_attachment" "codebuild-policy-attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  role       = aws_iam_role.codebuild-role.id
}