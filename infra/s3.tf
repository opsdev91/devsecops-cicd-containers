#Created Policy for IAM Role
resource "aws_iam_policy" "allow_s3" {

  name        = "${local.resource_name_prefix}-allow-s3-policy"
  description = "A policy to allow put Object s3"


  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:*"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : "arn:aws:s3:::*"
      }
    ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "attach_to_security_hub" {
  role       = aws_iam_role.security_hub.name
  policy_arn = aws_iam_policy.allow_s3.arn
}



resource "aws_s3_bucket" "data_security_hub" {
  bucket = "${local.resource_name_prefix}-${local.account_id}"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.data_security_hub.id
  versioning_configuration {
    status = "Enabled"
  }
}
