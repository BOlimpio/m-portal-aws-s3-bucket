variable "s3_bucket_name" {
  type        = string
  description = "The name of the bucket"
  default     = ""
}

variable "enable_default_policy" {
  description = "Enable or disable the default IAM policy for the S3 bucket. When enabled, it enforces secure practices for object uploads and HTTPS connections."
  type        = bool
  default     = false
}

###################################
### Lifecycle objects variables ###
###################################
variable "lifecycle_glacier_ir_object_prefix" {
  type        = string
  description = "Prefix of the identification of one or more objects to which the rule applies"
  default     = ""
}

variable "lifecycle_glacier_ir_transition_enabled" {
  type        = bool
  description = "Enable/disable lifecycle expiration of objects (e.g. `true` or `false`)"
  default     = false
}

variable "lifecycle_days_to_glacier_ir_transition" {
  type        = number
  description = "Specifies the number of days after object creation when the specific rule action takes effect"
  default     = 90
}

variable "lifecycle_days_to_expiration" {
  type        = number
  description = "Specifies the number of days after object creation when the specific rule action takes effect"
  default     = 30
}

variable "lifecycle_days_to_glacier_transition" {
  type        = number
  description = "Specifies the number of days after object creation when the specific rule action takes effect"
  default     = 90
}

variable "lifecycle_days_to_infrequent_storage_transition" {
  type        = number
  description = "Specifies the number of days after object creation when the specific rule action takes effect"
  default     = 60
}

variable "lifecycle_expiration_enabled" {
  type        = bool
  description = "Enable/disable lifecycle expiration of objects (e.g. `true` or `false`)"
  default     = false
}

variable "lifecycle_expiration_object_prefix" {
  type        = string
  description = "Prefix of the identification of one or more objects to which the rule applies"
  default     = ""
}

variable "lifecycle_glacier_object_prefix" {
  type        = string
  description = "Prefix of the identification of one or more objects to which the rule applies"
  default     = ""
}

variable "lifecycle_glacier_transition_enabled" {
  type        = bool
  description = "Enable/disable lifecycle expiration of objects (e.g. `true` or `false`)"
  default     = false
}

variable "lifecycle_infrequent_storage_object_prefix" {
  type        = string
  description = "Prefix of the identification of one or more objects to which the rule applies"
  default     = ""
}

variable "lifecycle_infrequent_storage_transition_enabled" {
  type        = bool
  description = "Enable/disable lifecycle expiration of objects (e.g. `true` or `false`)"
  default     = false
}

##############################################
### Lifecycle noncurrent objects variables ###
##############################################

variable "lifecycle_noncurrent_glacier_ir_object_prefix" {
  type        = string
  description = "Prefix of the identification of one or more noncurrent objects to which the rule applies"
  default     = ""
}

variable "lifecycle_noncurrent_glacier_ir_transition_enabled" {
  type        = bool
  description = "Enable/disable lifecycle expiration of noncurrent objects (e.g. `true` or `false`)"
  default     = false
}

variable "lifecycle_noncurrent_days_to_glacier_ir_transition" {
  type        = number
  description = "Specifies the number of days after noncurrent object creation when the specific rule action takes effect"
  default     = 90
}

variable "lifecycle_noncurrent_days_to_expiration" {
  type        = number
  description = "Specifies the number of days after noncurrent object creation when the specific rule action takes effect"
  default     = 30
}

variable "lifecycle_noncurrent_days_to_glacier_transition" {
  type        = number
  description = "Specifies the number of days after noncurrent object creation when the specific rule action takes effect"
  default     = 90
}

variable "lifecycle_noncurrent_days_to_infrequent_storage_transition" {
  type        = number
  description = "Specifies the number of days after noncurrent object creation when the specific rule action takes effect"
  default     = 60
}

variable "lifecycle_noncurrent_expiration_enabled" {
  type        = bool
  description = "Enable/disable lifecycle expiration of noncurrent objects (e.g. `true` or `false`)"
  default     = false
}

variable "lifecycle_noncurrent_expiration_object_prefix" {
  type        = string
  description = "Prefix of the identification of one or more noncurrent objects to which the rule applies"
  default     = ""
}

variable "lifecycle_noncurrent_glacier_object_prefix" {
  type        = string
  description = "Prefix of the identification of one or more noncurrent objects to which the rule applies"
  default     = ""
}

variable "lifecycle_noncurrent_glacier_transition_enabled" {
  type        = bool
  description = "Enable/disable lifecycle expiration of noncurrent objects (e.g. `true` or `false`)"
  default     = false
}

variable "lifecycle_noncurrent_infrequent_storage_object_prefix" {
  type        = string
  description = "Prefix of the identification of one or more noncurrent objects to which the rule applies"
  default     = ""
}

variable "lifecycle_noncurrent_infrequent_storage_transition_enabled" {
  type        = bool
  description = "Enable/disable lifecycle expiration of noncurrent objects (e.g. `true` or `false`)"
  default     = false
}

variable "versioning" {
  type        = string
  description = "Enable bucket versioning of objects: Enabled or Disabled"
  default     = "Disabled"
}

variable "kms_master_key_id" {
  type        = string
  description = "Set this to the value of the KMS key id. If this parameter is empty the default KMS master key is used"
  default     = ""
}

variable "attach_custom_policy" {
  description = "Flag to determine whether to attach a custom policy"
  type        = bool
  default     = false
}

variable "custom_iam_s3_policy" {
  type        = string
  description = "Custom IAM policy for S3"
  default     = ""
}


variable "force_destroy" {
  type        = bool
  description = "When true, forces the destruction of the S3 bucket and all its content. Use with caution."
  default     = false
}


variable "allowed_resource_arns" {
  type        = list(string)
  description = "List of ARNs for allowed resources"
  default     = []
}

variable "enable_restricted_bucket_access" {
  type        = bool
  description = "Whether to run the policy for s3_restricted_access_ids"
  default     = false
}

variable "enable_whitelists" {
  type        = bool
  description = "Whether to enable IP whitelisting"
  default     = false
}

variable "generic_policy_entries" {
  description = "List of entries for the generic policy"

  type = list(object({
    principal_type = string
    principal_ids  = list(string)
    actions        = list(string)
  }))

  default = []
}

variable "ip_whitelist" {
  description = "List of whitelisted IP addresses"
  type        = list(string)
  default     = []
}

variable "vpc_ids_whitelist" {
  description = "List of VPC IDs to whitelist for S3 access"
  type        = list(string)
  default     = []
}

variable "ip_whitelist_vpce" {
  description = "List of extra VPC Endpoint IDs to allow access to S3"
  type        = list(string)
  default     = []
}


variable "whitelist_actions" {
  description = "Actions that are denied by the whitelist"
  type        = list(string)
  default     = [
    "s3:PutObject*",
    "s3:GetObject*",
  ]
}

variable "enable_deny_unencrypted_object_uploads" {
  type        = bool
  description = "Whether to enforce Encrypted Object Uploads"
  default     = true
}

variable "additional_tags" {
  description = "A map of additional tags to add to the S3 bucket."
  type = map(string)
  default = {}
}