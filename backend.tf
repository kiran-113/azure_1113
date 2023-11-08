# terraform {
#   backend "s3" {
#     bucket = "tf-backend-1113"
#     key    = "tf-backend"
#     region = "us-east-1"
#   }
# }
terraform {
  backend "azurerm" {
    resource_group_name  = "azure-terraform-backend"
    storage_account_name = "aztfbackend1113"
    container_name       = "aztfbackend1113ct"
    key                  = "azure.terraform"

  }
}
