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

  public_key     = "ssh-rsa JustImagineThisIsARealPubkey"
  public_key2    = "ssh-rsa JustImagineThisIsARealPubkey2"
  project_region = "ca-central-1"
}
