# GCP SUBZONE

resource "google_dns_managed_zone" "gcp_sub_zone" {
  count = var.create_gcp_dns_zone ? 1 : 0
  name              = "${var.namespace}-zone"
  dns_name          = "${var.namespace}.gcp.${var.hosted-zone}."
  project           = var.gcp_project
  description       = "Managed by Terraform, Delegated Sub Zone for GCP for  ${var.namespace}"
  labels = {
    name = var.namespace
    owner = var.owner
    created-by = var.created-by
  }
}