


resource "aws_iam_user" "Prod_user" {
  name = var.user_name
  path = "/"
  tags = local.common_tags

}

resource "aws_iam_group" "devloper_group" {
  name = "var.group_name"
  path = "/"

}

resource "aws_iam_policy" "policy" {
  name        = "s3_access_policy"
  path        = "/"
  description = "Policy to allow access to S3 buckets"
  depends_on = [ aws_iam_group.devloper_group ]

  policy = jsonencode({
    version = "2012-10-17"
    statement = [
      {
        effect = "Allow"
        action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        resource = "*"
      }
    ]
    }
  )

}

resource "aws_iam_group_policy_attachment" "dev_attach" {
  group      = aws_iam_group.devloper_group.name
  policy_arn = aws_iam_policy.policy.arn

}

resource "aws_iam_user_group_membership" "user_group_membership" {
  user   = aws_iam_user.Prod_user.name
  groups = [aws_iam_group.devloper_group.name]

}