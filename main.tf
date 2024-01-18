resource "aws_s3_bucket" "private_bucket" {
  bucket        = lower(var.s3_bucket_name)
  force_destroy = var.force_destroy

  tags = merge(
    var.additional_tags,
    tomap({"Name" = lower(var.s3_bucket_name)})
  )
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.private_bucket.id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse" {
  bucket = aws_s3_bucket.private_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_id != "" ? var.kms_master_key_id : ""
      sse_algorithm     = var.kms_master_key_id != "" ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "non_versioning_bucket_lifecycle" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    id     = "transition-to-infrequent-access-storage"
    status = var.lifecycle_infrequent_storage_transition_enabled ? "Enabled" : "Disabled"

    filter {
      prefix = var.lifecycle_infrequent_storage_object_prefix
    }

    transition {
      days = var.lifecycle_days_to_infrequent_storage_transition
      storage_class   = "STANDARD_IA"
    }
  }

  rule {
    id     = "transition-noncurrent-to-infrequent-access-storage"
    status = var.lifecycle_noncurrent_infrequent_storage_transition_enabled ? "Enabled" : "Disabled"

    filter {
      prefix = var.lifecycle_noncurrent_infrequent_storage_object_prefix
    }

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_noncurrent_days_to_infrequent_storage_transition
      storage_class   = "STANDARD_IA"
    }
  }

  rule {
    id     = "transition-to-glacier"
    status = var.lifecycle_glacier_transition_enabled ? "Enabled" : "Disabled"

    filter {
      prefix = var.lifecycle_glacier_object_prefix
    }

    transition {
      days = var.lifecycle_days_to_glacier_transition
      storage_class   = "GLACIER"
    }
  }

  rule {
    id     = "transition-noncurrent-to-glacier"
    status = var.lifecycle_noncurrent_glacier_transition_enabled ? "Enabled" : "Disabled"

    filter {
      prefix = var.lifecycle_noncurrent_glacier_object_prefix
    }

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_noncurrent_days_to_glacier_transition
      storage_class   = "GLACIER"
    }
  }

  rule {
    id     = "transition-to-glacier-ir"
    status = var.lifecycle_glacier_ir_transition_enabled ? "Enabled" : "Disabled"

    filter {
      prefix = var.lifecycle_glacier_ir_object_prefix
    }

    transition {
      days = var.lifecycle_days_to_glacier_ir_transition
      storage_class   = "GLACIER_IR"
    }
  }

  rule {
    id     = "transition-noncurrent-to-glacier-ir"
    status = var.lifecycle_noncurrent_glacier_ir_transition_enabled ? "Enabled" : "Disabled"

    filter {
      prefix = var.lifecycle_noncurrent_glacier_ir_object_prefix
    }

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_noncurrent_days_to_glacier_ir_transition
      storage_class   = "GLACIER_IR"
    }
  }

  rule {
    id     = "expire-objects"
    status = var.lifecycle_expiration_enabled ? "Enabled" : "Disabled"

    filter {
      prefix = var.lifecycle_expiration_object_prefix
    }

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }

  rule {
    id     = "expire-noncurrent-objects"
    status = var.lifecycle_noncurrent_expiration_enabled ? "Enabled" : "Disabled"

    filter {
      prefix = var.lifecycle_noncurrent_expiration_object_prefix
    }

    noncurrent_version_expiration {
      noncurrent_days = var.lifecycle_noncurrent_days_to_expiration
    }
  }
}
