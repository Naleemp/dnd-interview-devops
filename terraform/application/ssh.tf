module "kms_key_for_ssh_keys" {
  source  = "cloudposse/kms-key/aws"
  version = "0.12.1"

  namespace = "dd"
  stage     = "example"
  name      = "example"

  description             = "key for storing ssh keys"
  deletion_window_in_days = 7
  enable_key_rotation     = false
  alias                   = "alias/example_ssh"
}

module "ssm_tls_ssh_key_pair" {
  source  = "cloudposse/ssm-tls-ssh-key-pair/aws"
  version = "0.10.2"

  namespace = "dd"
  stage     = "example"
  name      = "example"

  ssm_path_prefix   = "ssh_keys"
  ssh_key_algorithm = "RSA"
  kms_key_id        = module.kms_key_for_ssh_keys.key_id
}
