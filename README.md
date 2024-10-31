# Terraform Project: S3 Bucket with Replication and Notifications

This Terraform project creates an S3 bucket with replication, versioning, lifecycle policies, encryption, logging, and notifications, tailored for a production environment. It manages multi-region replication, lifecycle configuration, and SNS notifications.

## Project Structure

```
.
├── main.tf                 # Main module configuration
├── Makefile                # Make commands for check, plan, apply, destroy, etc.
├── provider.tf             # AWS provider and backend configuration
├── terraform.tfvars        # Variables with user-defined values
├── variables.tf            # Variables definition
└── s3-bucket/              # S3 bucket module
    ├── data.tf             # Data sources for IAM policy documents
    ├── provider-alias.tf   # Provider alias for replication configuration
    ├── s3-replication.tf   # Replication IAM roles and policies
    └── s3.tf               # S3 bucket, encryption, versioning, and lifecycle
```

## Modules

### Main Module
- **File**: `main.tf`
- **Description**: Defines the primary S3 bucket module, including bucket configuration, replication setup, SNS notifications, and IAM policies.

### S3 Bucket Module
- **File**: `s3-bucket/`
- **Description**: This module encapsulates S3 bucket-related resources, including bucket creation, logging, versioning, replication, lifecycle policies, and KMS encryption.

## Key Features

1. **S3 Bucket Replication**: Replicates objects from the main S3 bucket in `us-east-1` to a replica bucket in `us-west-2`.

2. **SNS Notifications**: Configures notifications for S3 object deletions, using SNS for email notifications.

3. **Encryption**: Uses KMS to encrypt S3 bucket objects with multi-region key support.

4. **Lifecycle Policies**: Configures lifecycle rules for object expiration and incomplete multipart upload cleanup.

5. **Versioning and Logging**: Enables S3 versioning and logging for better data tracking and recovery.

6. **IAM Policies**: Configures IAM policies for replication, notifications, and encryption.

## Usage

### Prerequisites

- Ensure Terraform is installed (v1.0+).
- AWS CLI configured with appropriate permissions.
- Install `tfsec` for security checks.

### Commands

Use the Makefile to run Terraform commands:

```bash
make check       # Initialize and validate Terraform
make plan        # Show Terraform plan
make test        # Run security checks with tfsec
make apply       # Apply the Terraform configuration
make destroy     # Destroy the resources
```

## Configuration
Adjust the following variables in terraform.tfvars to suit your environment:

```bash
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
```

## Makefile Targets
The Makefile includes several targets to streamline development tasks:

* `make check`: Runs Terraform initialization, format, and validation checks.
* `make plan`: Generates a Terraform execution plan.
* `make test`: Runs tfsec for security checks.
* `make apply`: Deploys the Terraform configuration.
* `make destroy`: Deletes all managed resources.