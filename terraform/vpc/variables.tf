# This will be parameterized by workspace variable files when workspace is implemented
variable "vpc_cidr_block" {
  type    = string
  default = "10.10.4.0/20"
}

variable "vpc_availability_zones" {
  type    = list(string)
  default = ["ca-central-1a", "ca-central-1b"]
}

## Transit gateway ID
variable "tgw_id" {
  type    = string
  default = "tgw-1234567890"
}

variable "tgw_cidr_blocks" {
  type = list(string)
  # itservices network
  default = ["10.0.0.0/8"]
}

variable "rfc1918" {
  type = list(string)
  # itservices network
  default = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}