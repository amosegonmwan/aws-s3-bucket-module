### IAM role (s3)
resource "aws_iam_role" "replication" {
  name               = var.replica_policy
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

### IAM policy (replication)
resource "aws_iam_policy" "replication" {
  name   = var.replica_policy
  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

### Replication destination s3 Bucket 
resource "aws_s3_bucket" "destination" {
  provider      = aws.west
  bucket        = var.bucket_replica
  force_destroy = true
}

### Replication destination s3 Bucket versioning
resource "aws_s3_bucket_versioning" "destination" {
  provider = aws.west
  bucket   = aws_s3_bucket.destination.id
  versioning_configuration {
    status = var.status
  }
}

### s3 bucket replication configuration
resource "aws_s3_bucket_replication_configuration" "replication" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.backend_bucket.id

  rule {
    id     = "backups"
    status = var.status

    delete_marker_replication {
      status = var.status
    }

    filter {}

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}