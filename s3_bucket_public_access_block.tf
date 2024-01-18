resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.private_bucket.id

  # Block objects from acquiring public acls - does not affect objects set prior to this setting being enabled 
  block_public_acls = true

  # Block calls to set a public bucket policy - does not affect bucket policy set prior to this setting being enabled
  block_public_policy = true

  # the following do not effect the persistence of public acls or public policies
  ignore_public_acls = true

  # Only the bucket owner and AWS Services can access this buckets if it has a public policy.
  restrict_public_buckets = true
}
