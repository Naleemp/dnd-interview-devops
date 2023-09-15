terraform {
  backend "s3" {
    bucket         = "backend-bucket-abc123"
    key            = "terraform/dnd-interview-tf/ca-central-1/vpc.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "terraform-lock"
  }
}
