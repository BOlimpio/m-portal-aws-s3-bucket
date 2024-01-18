output "s3_attributes" {
  value = aws_s3_bucket.private_bucket
}

# How to use output attributes
# e.g. arn = module.example.s3_attributes.arn OR module.example.s3_attributes["arn"]
