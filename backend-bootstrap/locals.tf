resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}


locals {
  sa_name = substr(lower("sttf${var.shortname}${random_string.suffix.result}"), 0, 24)

  tags = {
    keep      = "true" # freder ressursgruppa mot nattlig sletting
    purpose   = "terraform-backend"
    owner     = var.shortname
    managedby = "terraform"
  }
}
