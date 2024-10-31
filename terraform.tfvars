team           = "wd102"
status         = "Enabled"
env            = "prod"
bucket_name    = "wemadevops-wd102-terraform-backend-2024"
bucket_replica = "wemadevops-wd102-terraform-backend-2024-replica"
region         = "us-east-1"
region_replica = "us-west-2"
topic          = "s3-event-notification-topic-backend"
email_addr     = "john.doe@gmail.com"
replica_policy = "wemadevops-wd102-iam-policy-terraform-backend"
