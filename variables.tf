# General
variable "owner" {
  description = "Person Deploying this Stack e.g. john-doe"
}

variable "namespace" {
  description = "Name of the zone e.g. demo"
}

variable "created-by" {
  description = "Tag used to identify resources created programmatically by Terraform"
  default     = "terraform"
}

variable "hosted-zone" {
  description = "The name of the dns zone on Route 53 that will be used as the master zone "
}

# AWS

variable "create_aws_dns_zone" {
  description = "Set to true if you want to deploy the AWS delegated zone."
  type        = bool
  default     = "false"
}

variable "aws_region" {
  description = "The region to create resources."
  default     = "eu-west-2"
}

# Azure

variable "create_azure_dns_zone" {
  description = "Set to true if you want to deploy the Azure delegated zone."
  type        = bool
  default     = "false"
}

variable "azure_location" {
  description = "The azure location to deploy the DNS service"
  default     = "West Europe"
}

# GCP

variable "create_gcp_dns_zone" {
  description = "Set to true if you want to deploy the Azure delegated zone."
  type        = bool
  default     = "false"
}

variable "gcp_project" {
  description = "GCP project name"
}

variable "gcp_region" {
  description = "GCP region, e.g. us-east1"
  default     = "europe-west3"
}