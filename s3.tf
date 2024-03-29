# Configure S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "zhenya.babkenasoyan.com"
  force_destroy = true
  
  website {
    index_document = "index.html"
  }
}

# Upload an index.html file to the S3 bucket
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "index.html" 
  source = "C:/index.html" 
  content_type = "text/html"
}

# Create an S3 website endpoint
data "aws_s3_bucket" "my_bucket_details" {
  bucket = aws_s3_bucket.my_bucket.id
}

# Create S3 bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    =["s3:GetObject"],
        Resource  =[ "${aws_s3_bucket.my_bucket.arn}/*" ]
      }
    ]
  })
}

# Configure S3 bucket public access settings
resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}