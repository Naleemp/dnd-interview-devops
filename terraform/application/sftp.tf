resource "aws_transfer_server" "sftp-example" {
  security_policy_name   = "TransferSecurityPolicy-2018-11"
  identity_provider_type = "AWS_DIRECTORY_SERVICE"
  protocols              = ["SFTP"]
  directory_id           = aws_directory_service_directory.example.id
  endpoint_type          = "VPC"
  endpoint_details {
    subnet_ids         = [data.terraform_remote_state.vpc.outputs.public_subnets.0]
    security_group_ids = [data.terraform_remote_state.vpc.outputs.sg.sg_web.security_group_id]
    vpc_id             = [data.terraform_remote_state.vpc.outputs.vpc_id][0]
    address_allocation_ids = [
      data.terraform_remote_state.vpc.outputs.eip.sftp_eip.allocation_id,
    ]
  }
  tags = {
    Name                           = "sftp-example"
    "transfer:customHostname"      = "example.dyedurham.dev"
    "transfer:route53HostedZoneId" = "/hostedzone/abc123"
  }

  tags_all = {
    "transfer:customHostname"      = "example.dyedurham.dev"
    "transfer:route53HostedZoneId" = "/hostedzone/abc123"
  }
}

resource "aws_iam_role" "sftp-example-role" {
  name = "sftp-transfer-user-iam-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "sftp-example-policy" {
  name   = "sftp-transfer-user-iam-policy"
  role   = aws_iam_role.sftp-example-role.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowFullAccesstoS3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket" "s3-sftp-example" {
  bucket = var.sftp_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "s3-sftp-example-owners" {
  bucket = aws_s3_bucket.s3-sftp-example.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "s3-sftp-example-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3-sftp-example-owners]

  bucket = aws_s3_bucket.s3-sftp-example.id
  acl    = var.sftp_acl_value
}
