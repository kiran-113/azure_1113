resource "azurerm_resource_group" "azure_my_rg" {
  count = length(var.resource_group_name)
  name  = "${var.prefix}-${element(var.resource_group_name, count.index)}"
  #name     = "${var.prefix}-${count.index}"
  location = var.location
}
