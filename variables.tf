variable "access_key" {}
variable "secret_key" {}
variable "pubkey" {}
variable "ssh_private_key" {}
variable "vault_instance_count" {
    default = 3
}

variable "region" {
    default = "ap-northeast-1"
}

variable "vault_instance_type" {
    default = "t2.large"
}

variable "availability_zones" {
    type = "list"
    default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "vpc_cidr" {
    default = "10.10.0.0/16"
}

variable "pubic_subnets_cidr" {
    type = "list"
    default = ["10.10.0.0/24", "10.10.1.0/24"]
}

variable "public_subnet_name" {
    default = "public"
}

variable "ami" {
    default = "ami-06d9ad3f86032262d"
}

variable "vault_instance_name" {
    default = "vault"
}

variable "tags" {
    type        = "map"
    default     = {}
    description = "Key/value tags to assign to all AWS resources"
}

variable "vault_dl_url" {
    default = "https://releases.hashicorp.com/vault/1.1.2/vault_1.1.2_linux_amd64.zip"
}