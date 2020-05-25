terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "tkaburagi"
    workspaces {
      name = "vault-aws"
    }
  }
}