resource "random_string" "unique_name" {
  length  = 8
  lower   = true
  special = false
  upper   = false
}