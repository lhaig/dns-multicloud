# Remote Backend Configuration:
terraform {
  required_version = ">= 0.11.0"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "dns-multicloud-org"
    workspaces {
      name = "dns-multicloud"
    }
  }
}

# AWS General Configuration
provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

# GCP General Configuration
provider "google" {
  version = "~> 2.9"
  project = var.gcp_project
  region  = var.gcp_region
}

# Azure General Configuration
provider "azurerm" {
  version = "~>1.32.1"
}