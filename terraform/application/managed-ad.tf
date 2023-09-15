resource "aws_directory_service_directory" "example" {
  name     = "example.dyedurham.dev"
  password = aws_secretsmanager_secret_version.mad-password.secret_string
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  }

  tags = {
    Project = "example"
  }
}