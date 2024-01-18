# m-portal-aws-s3-private-bucket
This Terraform module facilitates the creation of an S3 bucket on AWS with customizable policies, storage transitions, and more. 
**For additional resources, examples, and community engagement**, check out the portal [Cloud Collab Hub](https://cloudcollab.com) :cloud:.
## Usage

```
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

```

For more detailed examples and use cases, check out the files in the how-to-usage directory. They provide additional scenarios and explanations for leveraging the features of the aws_s3_private_bucket module.

## Features

Below features are supported:

  * Pre-configured S3 policy for 'Deny Unencrypted Object Uploads', 'Enforce HTTPS Connections', 'Whitelist' and 'Access Control'
  * Allow add custom policy
  * Bucket versioning
  * KMS cryptography  

## Prerequisites

terraform version >= 1.0
aws provider version >= 4.0

## Module Inputs

| Variable                                      | Type           | Default | Required | Description                                                                                                                |
|-----------------------------------------------|----------------|---------|----------|----------------------------------------------------------------------------------------------------------------------------|
| s3_bucket_name                                | string         | ""      | Yes      | The name of the bucket.                                                                                                     |
| enable_default_policy                         | bool           | false   | No       | Enable or disable the default IAM policy for the S3 bucket. When enabled, it enforces secure practices for object uploads and HTTPS connections.                                      |
| lifecycle_glacier_ir_object_prefix            | string         | ""      | No       | Prefix of the identification of one or more objects to which the rule applies.                                              |
| lifecycle_glacier_ir_transition_enabled       | bool           | false   | No       | Enable/disable lifecycle expiration of objects (e.g., `true` or `false`).                                                 |
| lifecycle_days_to_glacier_ir_transition       | number         | 90      | No       | Specifies the number of days after object creation when the specific rule action takes effect.                            |
| lifecycle_days_to_expiration                  | number         | 30      | No       | Specifies the number of days after object creation when the specific rule action takes effect.                            |
| lifecycle_days_to_glacier_transition          | number         | 90      | No       | Specifies the number of days after object creation when the specific rule action takes effect.                            |
| lifecycle_days_to_infrequent_storage_transition| number         | 60      | No       | Specifies the number of days after object creation when the specific rule action takes effect.                            |
| lifecycle_expiration_enabled                  | bool           | false   | No       | Enable/disable lifecycle expiration of objects (e.g., `true` or `false`).                                                 |
| lifecycle_expiration_object_prefix            | string         | ""      | No       | Prefix of the identification of one or more objects to which the rule applies.                                              |
| lifecycle_glacier_object_prefix               | string         | ""      | No       | Prefix of the identification of one or more objects to which the rule applies.                                              |
| lifecycle_glacier_transition_enabled          | bool           | false   | No       | Enable/disable lifecycle expiration of objects (e.g., `true` or `false`).                                                 |
| lifecycle_infrequent_storage_object_prefix    | string         | ""      | No       | Prefix of the identification of one or more objects to which the rule applies.                                              |
| lifecycle_infrequent_storage_transition_enabled| bool         | false   | No       | Enable/disable lifecycle expiration of objects (e.g., `true` or `false`).                                                 |
| lifecycle_noncurrent_glacier_ir_object_prefix | string         | ""      | No       | Prefix of the identification of one or more noncurrent objects to which the rule applies.                                 |
| lifecycle_noncurrent_glacier_ir_transition_enabled| bool        | false   | No       | Enable/disable lifecycle expiration of noncurrent objects (e.g., `true` or `false`).                                    |
| lifecycle_noncurrent_days_to_glacier_ir_transition| number     | 90      | No       | Specifies the number of days after noncurrent object creation when the specific rule action takes effect.                 |
| lifecycle_noncurrent_days_to_expiration       | number         | 30      | No       | Specifies the number of days after noncurrent object creation when the specific rule action takes effect.                 |
| lifecycle_noncurrent_days_to_glacier_transition| number      | 90      | No       | Specifies the number of days after noncurrent object creation when the specific rule action takes effect.                 |
| lifecycle_noncurrent_days_to_infrequent_storage_transition| number | 60      | No       | Specifies the number of days after noncurrent object creation when the specific rule action takes effect.                 |
| lifecycle_noncurrent_expiration_enabled       | bool           | false   | No       | Enable/disable lifecycle expiration of noncurrent objects (e.g., `true` or `false`).                                    |
| lifecycle_noncurrent_expiration_object_prefix | string         | ""      | No       | Prefix of the identification of one or more noncurrent objects to which the rule applies.                                 |
| lifecycle_noncurrent_glacier_object_prefix    | string         | ""      | No       | Prefix of the identification of one or more noncurrent objects to which the rule applies.                                 |
| lifecycle_noncurrent_glacier_transition_enabled| bool         | false   | No       | Enable/disable lifecycle expiration of noncurrent objects (e.g., `true` or `false`).                                    |
| lifecycle_noncurrent_infrequent_storage_object_prefix| string  | ""      | No       | Prefix of the identification of one or more noncurrent objects to which the rule applies.                                 |
| lifecycle_noncurrent_infrequent_storage_transition_enabled| bool | false   | No       | Enable/disable lifecycle expiration of noncurrent objects (e.g., `true` or `false`).                                    |
| versioning                                    | string         | "Disabled" | No   | Enable bucket versioning of objects: "Enabled" or "Disabled".                                                              |
| kms_master_key_id                             | string         | ""      | No       | Set this to the value of the KMS key id. If this parameter is empty, the default KMS master key is used.                 |
| attach_custom_policy                          | bool           | false   | No       | Flag to determine whether to attach a custom policy.                                                                         |
| custom_iam_s3_policy                          | string         | ""      | No       | Custom IAM policy for S3.                                                                                                  |
| force_destroy                                 | bool           | false   | No       | When true, forces the destruction of the S3 bucket and all its content. Use with caution.                                  |
| allowed_resource_arns                         | list(string)   | []      | No       | List of ARNs for allowed resources.                                                                                       

 |
| enable_restricted_bucket_access               | bool           | false   | No       | Whether to run the policy for s3_restricted_access_ids.                                                                   |
| enable_whitelists                             | bool           | false   | No       | Whether to enable IP whitelisting.                                                                                         |
| generic_policy_entries                        | list(object)   | []      | No       | List of entries for the generic policy.                                                                                    |
| ip_whitelist                                  | list(string)   | []      | No       | List of whitelisted IP addresses.                                                                                         |
| vpc_ids_whitelist                             | list(string)   | []      | No       | List of VPC IDs to whitelist for S3 access.                                                                               |
| ip_whitelist_vpce                             | list(string)   | []      | No       | List of extra VPC Endpoint IDs to allow access to S3.                                                                     |
| whitelist_actions                             | list(string)   | ["s3:PutObject*", "s3:GetObject*"] | No | Actions that are denied by the whitelist.                                                                     |
| enable_deny_unencrypted_object_uploads        | bool           | true    | No       | Whether to enforce Encrypted Object Uploads.                                                                               |
| additional_tags                               | map(string)    | {}      | No       | A map of additional tags to add to the S3 bucket.                                                                          |
## Module outputs

| Name            | Description                        |
|-----------------|------------------------------------|
| s3_attributes   | Attributes of the created S3 bucket |
## How to Use Output Attributes
arn = module.example_s3_bucket.s3_attributes.arn
**OR**
arn = module.example_s3_bucket.s3_attributes["arn"]

## License
This project is licensed under the MIT License - see the [MIT License](https://opensource.org/licenses/MIT) file for details.

## Contributing
Contributions are welcome! Please follow the guidance below for details on how to contribute to this project:
1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a pull request