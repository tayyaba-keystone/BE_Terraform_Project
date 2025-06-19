# EC2 User
resource "aws_iam_user" "ec2_user" {
  name = "ec2-user"
}

resource "aws_iam_user_login_profile" "ec2_user" {
  user                    = aws_iam_user.ec2_user.name
  password_reset_required = true
}

resource "aws_iam_user_policy_attachment" "ec2_user_policy" {
  user       = aws_iam_user.ec2_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# S3 User
resource "aws_iam_user" "s3_user" {
  name = "s3-user"
}

resource "aws_iam_user_login_profile" "s3_user" {
  user                    = aws_iam_user.s3_user.name
  password_reset_required = true
}

resource "aws_iam_user_policy_attachment" "s3_user_policy" {
  user       = aws_iam_user.s3_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# ✅ Attach password change policy
resource "aws_iam_user_policy_attachment" "ec2_user_self_manage_password" {
  user       = aws_iam_user.ec2_user.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_user_policy_attachment" "s3_user_self_manage_password" {
  user       = aws_iam_user.s3_user.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

# Output IAM sign-in URL (Replace ACCOUNT_ID)
output "iam_users_credentials" {
  value = {
    "IAM Sign-in URL" = "https://YOUR-AWS-ACCOUNT-ID.signin.aws.amazon.com/console"
    "ec2-user"        = { username = aws_iam_user.ec2_user.name }
    "s3-user"         = { username = aws_iam_user.s3_user.name }
  }
  sensitive = true
}