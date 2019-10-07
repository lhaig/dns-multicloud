data "aws_route53_zone" "main" {
  name = var.hosted-zone
}

# AWS SUBZONE 

resource "aws_route53_zone" "aws_sub_zone" {
  name = "${var.namespace}.aws.${var.hosted-zone}"
  comment = "Managed by Terraform, Delegated Sub Zone for AWS for ${var.namespace}"

  tags = {
    name        = var.namespace
    owner       = var.owner
    created-by  = var.created-by
  }
}

resource "aws_route53_record" "aws_sub_zone_ns" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.namespace}.aws.${var.hosted-zone}"
  type    = "NS"
  ttl     = "30"

  records = [
    for awsns in aws_route53_zone.aws_sub_zone.name_servers:
    awsns
  ]
}
