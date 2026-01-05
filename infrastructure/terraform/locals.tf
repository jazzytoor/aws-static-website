locals {
  subdomain = var.service

  default_tags = {
    Name = var.service
  }
}
