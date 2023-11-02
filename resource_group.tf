resource "azurerm_resource_group" "azure_my_rg" {
  #name     = "terraform-rg"
  name = "${var.prefix}-resources"
  #terraform-resources
  location = var.location
}
