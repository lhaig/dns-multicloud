output "aws_sub_zone_id" {
  value = aws_route53_zone.aws_sub_zone.zone_id
}

output "aws_sub_zone_nameservers" {
  value = aws_route53_zone.aws_sub_zone.name_servers
}