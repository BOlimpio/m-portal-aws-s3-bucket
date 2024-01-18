data "aws_iam_policy_document" "private" {
  source_policy_documents = compact([
    var.custom_iam_s3_policy,
    var.enable_deny_unencrypted_object_uploads ? data.aws_iam_policy_document.deny_unencrypted_object_uploads[0].json : "",
    var.enable_default_policy ? data.aws_iam_policy_document.default[0].json : "",
    var.enable_restricted_bucket_access ? data.aws_iam_policy_document.access_control[0].json : "",
    var.enable_whitelists ? data.aws_iam_policy_document.whitelists[0].json : "",
  ])
}

data "aws_iam_policy_document" "deny_unencrypted_object_uploads" {
  count = var.enable_deny_unencrypted_object_uploads ? 1 : 0
    statement {
      sid       = "DenyIncorrectEncryptionHeader"
      effect    = "Deny"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.private_bucket.arn}/*"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "StringNotEquals"
      values   = ["${var.kms_master_key_id != "" ? "aws:kms" : "AES256"}"]
      variable = "s3:x-amz-server-side-encryption"
    }
  }
}

data "aws_iam_policy_document" "default" {
  count = var.enable_default_policy ? 1 : 0

  statement {
    sid    = "Default"
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.private_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms", "AES256"]
    }
  }

  statement {
    sid = "EnforceHTTPSConnections"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.private_bucket.arn}/*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "access_control" {
  count = var.enable_restricted_bucket_access ? 1 : 0

  statement {
    sid    = "AllowS3AccessForARNS"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    
    principals {
      type        = "AWS"
      identifiers = var.allowed_resource_arns
    }

    resources = [
      "${aws_s3_bucket.private_bucket.arn}",
      "${aws_s3_bucket.private_bucket.arn}/*",
    ]
  }
}


data "aws_iam_policy_document" "whitelists" {
  count = var.enable_whitelists ? 1 : 0

  statement {
    sid = "AllowS3AccessForIPWhitelistEndPoints"

    actions = var.whitelist_actions

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      aws_s3_bucket.private_bucket.arn,
      "${aws_s3_bucket.private_bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = var.ip_whitelist
    }

    condition {
      test     = "StringNotLike"
      variable = "aws:sourceVpce"
      values   = var.ip_whitelist_vpce
    }

    condition {
      test     = "StringNotLike"
      variable = "aws:sourceVpc"
      values   = var.vpc_ids_whitelist
    }
  }
}
