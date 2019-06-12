provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "grahamgilbert"
    token        = "##TF_VAR_token##"

    workspaces {
      name = "macdevops-2019-munkireport"
    }
  }
}
