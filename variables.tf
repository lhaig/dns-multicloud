# General
variable "owner" {
  description = "Person Deploying this Stack e.g. john-doe"
  default = "yulei"
}

variable "namespace" {
  description = "Name of the zone e.g. demo"
  default = "yulei"
}

variable "created-by" {
  description = "Tag used to identify resources created programmatically by Terraform"
  default     = "terraform"
}

variable "hosted-zone" {
  description = "The name of the dns zone on Route 53 that will be used as the master zone "
  default = "hashidemos.io"
}

# AWS

variable "create_aws_dns_zone" {
  description = "Set to true if you want to deploy the AWS delegated zone."
  type        = bool
  default     = "true"
}

variable "aws_region" {
  description = "The region to create resources."
  default     = "ap-southeast-2"
}

# Azure

variable "create_azure_dns_zone" {
  description = "Set to true if you want to deploy the Azure delegated zone."
  type        = bool
  default     = "true"
}

variable "azure_location" {
  description = "The azure location to deploy the DNS service"
  default     = "Australia Central 2"
}

# GCP

variable "create_gcp_dns_zone" {
  description = "Set to true if you want to deploy the Azure delegated zone."
  type        = bool
  default     = "true"
}

variable "gcp_project" {
  description = "GCP project name"
  default="yulei-playground"
}

variable "gcp_region" {
  description = "GCP region, e.g. us-east1"
  default     = "australia-southeast1"
}