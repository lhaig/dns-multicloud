data "aws_route53_zone" "main" {
  name = var.hosted-zone
}

# AWS SUBZONE 

resource "aws_route53_zone" "aws_sub_zone" {
  count = var.create_aws_dns_zone ? 1 : 0
  name = "${var.namespace}.aws.${var.hosted-zone}"
  comment = "Managed by Terraform, Delegated Sub Zone for AWS for ${var.namespace}"

  tags = {
    name        = var.namespace
    owner       = var.owner
    created-by  = var.created-by
  }
}

resource "aws_route53_record" "aws_sub_zone_ns" {
  count = var.create_aws_dns_zone ? 1 : 0
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.namespace}.aws.${var.hosted-zone}"
  type    = "NS"
  ttl     = "30"

  records = [
    for awsns in aws_route53_zone.aws_sub_zone.0.name_servers:
    awsns
  ]
}

# Azure SUBZONE 

resource "aws_route53_zone" "azure_sub_zone" {
  count = var.create_azure_dns_zone ? 1 : 0
  name = "${var.namespace}.azure.${var.hosted-zone}"
  comment = "Managed by Terraform, Delegated Sub Zone for Azure for ${var.namespace}"

  tags = {
    name        = var.namespace
    owner       = var.owner
    created-by  = var.created-by
  }
}

resource "aws_route53_record" "azure_sub_zone_ns" {
  count = var.create_azure_dns_zone ? 1 : 0
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.namespace}.azure.${var.hosted-zone}"
  type    = "NS"
  ttl     = "30"

  records = [
    for azurens in azurerm_dns_zone.azure_sub_zone.0.name_servers:
    azurens
  ]
}

# GCP SubZone

resource "aws_route53_zone" "gcp_sub_zone" {
  count = var.create_gcp_dns_zone ? 1 : 0
  name          = "${var.namespace}.gcp.${var.hosted-zone}"
  comment       = "Managed by Terraform, Delegated Sub Zone for GCP for  ${var.namespace}"
  force_destroy = false
  tags = {
    name           = var.namespace
    owner          = var.owner
    created-by     = var.created-by
 }
}

 resource "aws_route53_record" "gcp_sub_zone" {
   count = var.create_gcp_dns_zone ? 1 : 0
   zone_id = "${data.aws_route53_zone.main.zone_id}"
   name    = "${var.namespace}.gcp.${var.hosted-zone}"
   type    = "NS"
   ttl     = "30"

   records = [ 
     for gcpns in google_dns_managed_zone.gcp_sub_zone.0.name_servers:
     gcpns
    ]
 }
