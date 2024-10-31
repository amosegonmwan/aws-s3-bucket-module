module "backend" {
  source = "./s3-bucket"
  team           = var.team
  status         = var.status
  env            = var.env
  bucket_name    = var.bucket_name
  bucket_replica = var.bucket_replica
  region         = var.region
  region_replica = var.region_replica
  topic          = var.topic
  email_addr     = var.email_addr
  replica_policy = var.replica_policy
}
