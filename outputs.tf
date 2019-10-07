output "aws_sub_zone_id" {
  value = aws_route53_zone.aws_sub_zone.zone_id
}

output "aws_sub_zone_nameservers" {
  value = aws_route53_zone.aws_sub_zone.name_servers
}

output "gcp_dns_zone_name" {
  value = google_dns_managed_zone.gcp_sub_zone.name
}

output "gcp_dns_zone_nameservers" {
  value = google_dns_managed_zone.gcp_sub_zone.name_servers
}