resource "azurerm_resource_group" "dns_resource_group" {
  name     = "${var.namespace}DNSrg"
  location = var.azure_location
}

resource "azurerm_dns_zone" "azure_sub_zone" {
  name                = "${var.namespace}.azure.${var.hosted-zone}"
  resource_group_name = "${azurerm_resource_group.dns_resource_group.name}"
  tags = {
    name        = var.namespace
    owner       = var.owner
    created-by  = var.created-by
  }
}