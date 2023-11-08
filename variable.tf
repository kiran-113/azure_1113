variable "prefix" {
  default = "terraform"
}

variable "location" {
  default = "West Europe"

}

variable "resource_group_name" {
  type    = list(string)
  default = ["rg1"]

}
