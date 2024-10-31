### s3 bucket creation 
resource "aws_s3_bucket" "backend_bucket" {
  bucket = var.bucket_name

  force_destroy = true

  tags = {
    Environment = local.division
  }
}

locals {
  division = "${var.team}-${var.env}"
}

### s3 bucket logging
resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.backend_bucket.id

  target_bucket = aws_s3_bucket.backend_bucket.id
  target_prefix = "log/"
}

### s3 versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.backend_bucket.id
  versioning_configuration {
    status = var.status
  }
}

### s3 public access block
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.backend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

### KMS encryption
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  multi_region            = true
  policy                  = data.aws_iam_policy_document.kms.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.backend_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

### s3 Event notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.backend_bucket.id

  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectRemoved:*"]
    filter_suffix = ".log"
  }
}

### SNS Topic
resource "aws_sns_topic" "topic" {
  name              = var.topic
  policy            = data.aws_iam_policy_document.topic.json
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "state_delete_target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email_addr
}

### s3 Lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  bucket = aws_s3_bucket.backend_bucket.id

  rule {
    id     = "expiration"
    status = var.status

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
}