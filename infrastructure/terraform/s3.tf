module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "${local.subdomain}-"

  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_policy.json

  tags = local.default_tags
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

module "object" {
  source  = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version = "~> 5.0"

  bucket       = module.s3.s3_bucket_id
  key          = "index.html"
  content_type = "text/html"

  # file_source = "../../index.html"
  content_base64 = filebase64("../../app/index.html")

  tags = local.default_tags
}
