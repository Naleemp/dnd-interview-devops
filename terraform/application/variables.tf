# This will be parameterized by workspace variable files when workspace is implemented
variable "example_domain_name" {
  type    = string
  default = "dyedurham.dev"
}

variable "terraform_backend_bucket_name" {
  type    = string
  default = ""
}

variable "web_size" {
  type    = string
  default = "m5.4xlarge"
}

variable "log_retention_in_days" {
  type    = number
  default = 60
}

variable "instance_count_web" {
  default = "3"
}

variable "instance_count_app" {
  default = "3"
}

variable "availability_zones" {
  default = ["ca-central-1a", "ca-central-1b"]
}

variable "ami" {
  default = "ami-AssumeItsWindows"
}

variable "ami_type" {
  default = "t2.large"
}

variable "sg_alb" {
  type    = list(string)
  default = ["sg-abc123"]
}

variable "subnet_alb" {
  type    = list(string)
  default = ["subnet-abc124", "subnet-abc125"]
}

variable "private_subnet_tag" {
  default = "application-example-private*"
}

variable "sftp_bucket_name" {
  default = "example-s3-sftp"
}

variable "sftp_user_name" {
  default = "example-user"
}

variable "sftp_acl_value" {
  default = "private"
}