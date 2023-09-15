resource "random_password" "mad-password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"

  lifecycle {
    ignore_changes = [
      length,
      special,
      override_special,
    ]
  }
}

resource "aws_secretsmanager_secret" "secretpassword" {
  name = "example-secret"
}

resource "aws_secretsmanager_secret_version" "mad-password" {
  secret_id     = aws_secretsmanager_secret.secretpassword.id
  secret_string = random_password.mad-password.result
  #sensitive = "true"
}