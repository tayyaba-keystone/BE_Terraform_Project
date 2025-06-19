
# Create S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-public-s3-bucket-1207"  # Change this to a unique name
}

# Disable Block Public Access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.example_bucket.id
  block_public_acls       = false
  block_public_policy     = false  # ✅ This allows public policies
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set a Public Read Bucket Policy
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.example_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-public-s3-bucket-1207/*"
    }
  ]
}
POLICY
}

# Upload an Object (Without ACL)
resource "aws_s3_object" "file_upload" {
  bucket       = aws_s3_bucket.example_bucket.id
  key          = "logo.jpg"  # Object Name
  source       = "C:\\Users\\Admin\\Desktop\\logo.jpg"  # Local File Path
  content_type = "image/jpeg"  # ✅ Set correct content type
}
