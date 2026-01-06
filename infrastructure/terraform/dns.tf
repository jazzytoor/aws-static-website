module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 6.0"

  providers = {
    aws = aws.us_east_1
  }

  validation_method = "DNS"

  domain_name               = var.domain
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = ["${local.subdomain}.${var.domain}"]

  tags = local.default_tags
}

module "records" {
  source  = "terraform-aws-modules/route53/aws"
  version = "~> 6.0"

  create_zone = false
  name        = var.domain

  records = {
    cloudfront = {
      name = local.subdomain
      type = "A"
      alias = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    }
  }
}
