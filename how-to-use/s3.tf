module "example_s3_bucket" {
  source = "github.com/BOlimpio/m-portal-aws-s3-bucket.git?ref=v1.0.0"

  s3_bucket_name = "cloudymos-bucket"

  enable_default_policy = true

  custom_iam_s3_policy = data.aws_iam_policy_document.custom_policy.json

  versioning = "Enabled"

  kms_master_key_id = "arn:aws:kms:us-east-1:021889093106:key/67b65ad8-a040-4e80-aa0d-05c6488a2509"

  # Enable control access policy to specific arns
  # enable_restricted_bucket_access = true
  # allowed_resource_arns           = ["arn:aws:s3:::allowed-resource"]

  # Lifecycle policies
  lifecycle_infrequent_storage_transition_enabled = true
  lifecycle_infrequent_storage_object_prefix    = "infrequent-storage-prefix"
  lifecycle_days_to_infrequent_storage_transition = 30  

  lifecycle_glacier_transition_enabled         = true
  lifecycle_glacier_object_prefix               = "glacier-prefix"
  lifecycle_days_to_glacier_transition          = 60

  lifecycle_glacier_ir_transition_enabled      = true
  lifecycle_glacier_ir_object_prefix            = "glacier-ir-prefix"
  lifecycle_days_to_glacier_ir_transition       = 90

  lifecycle_expiration_enabled                  = true
  lifecycle_expiration_object_prefix            = "expiration-prefix"
  lifecycle_days_to_expiration                  = 120

  # Noncurrent Lifecycle policies
  lifecycle_noncurrent_infrequent_storage_transition_enabled = true
  lifecycle_noncurrent_infrequent_storage_object_prefix    = "noncurrent-infrequent-storage-prefix"
  lifecycle_noncurrent_days_to_infrequent_storage_transition = 45  

  lifecycle_noncurrent_glacier_transition_enabled         = true
  lifecycle_noncurrent_glacier_object_prefix               = "noncurrent-glacier-prefix"
  lifecycle_noncurrent_days_to_glacier_transition          = 90

  lifecycle_noncurrent_glacier_ir_transition_enabled      = true
  lifecycle_noncurrent_glacier_ir_object_prefix            = "noncurrent-glacier-ir-prefix"
  lifecycle_noncurrent_days_to_glacier_ir_transition       = 180

  lifecycle_noncurrent_expiration_enabled                  = true
  lifecycle_noncurrent_expiration_object_prefix            = "noncurrent-expiration-prefix"
  lifecycle_noncurrent_days_to_expiration                  = 360

  #Enable whitelist access to bucket
  enable_whitelists = true
  ip_whitelist      = ["192.168.1.1", "10.0.0.0/24"]
  vpc_ids_whitelist = ["vpc-id-1", "vpc-id-2"]
  ip_whitelist_vpce = ["vpce-id-1", "vpce-id-2"]
  whitelist_actions = [
    "s3:PutObject*",
    "s3:GetObject*",
  ]

  enable_deny_unencrypted_object_uploads = true

  additional_tags = {
    Environment = "Test",
    Owner       = "Bruno Olimpio",
    Project     = "Cloudymos",
  }
}



data "aws_iam_policy_document" "custom_policy" {
  statement {
    sid       = "AllowRootUserGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::cloudymos-bucket/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}
