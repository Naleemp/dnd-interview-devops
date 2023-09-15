locals {
  common_tags = {
    # Name
    "Application ID"   = "example"
    "Application Role" = "application"
    "orgaccountbackup" = "true"
    "createdby"        = "thomas.taege"
    "managedby"        = "terraform"
    "environment"      = "example"
  }
  project_region = "ca-central-1"
}
