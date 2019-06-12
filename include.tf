provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "grahamgilbert"

    workspaces {
      name = "macdevops-2019-munkireport"
    }
  }
}