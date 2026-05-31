# resource "aws_s3_bucket" "firstbucket" {
#   bucket = var.bucket_name
# }


# #--AWS now recommends: -- aws_s3_bucket_acl{}

# # Bucket Policies
# # IAM policies
# # Public Access Block
# # resource "aws_s3_bucket_acl" "demoacl" {
# #   bucket = aws_s3_bucket.firstbucket.id
# #   # acl = "private"
# # }



# resource "aws_s3_bucket_public_access_block" "block" {
#   bucket = aws_s3_bucket.firstbucket.id
#   block_public_acls = true
#   block_public_policy = true
#   ignore_public_acls = true
#   restrict_public_buckets = true
# }

# #Origin access control--- handshake between CloudFront and backend resources 
# resource "aws_cloudfront_origin_access_control" "oac" {
#   name = "demo-oac"
#   description = "Example Policy"
#   origin_access_control_origin_type = "s3"
#   signing_behavior = "always"
#   signing_protocol = "sigv4"
# }

# resource "aws_s3_bucket_policy" "allow_cf" {
#   bucket = aws_s3_bucket.firstbucket.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowCloudFrontServicePrincipal"
#         Effect = "Allow"

#         Principal = {
#           Service = "cloudfront.amazonaws.com"
#         }

#         Action = [
#           "s3:GetObject"
#         ]

#         Resource = "${aws_s3_bucket.firstbucket.arn}/*"

#         Condition = {
#           StringEquals = {
#             "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
#           }
#         }
#       }
#     ]
#   })
# }

# data "aws_caller_identity" "current" {}


# # data "aws_iam_policy_document" "allow_access_from_another_account"{
# #   statement {
# #     principals {
      
# #     }
# #   }
# # }

# resource "aws_s3_object" "obj" {
#   for_each = fileset("${path.module}/www","**/*")
#   bucket = aws_s3_bucket.firstbucket.id
#   key = each.value
#   source = "${path.module}/www/${each.value}" #where file is located
#   etag =filemd5("${path.module}/www/${each.value}") #converting all the files that are present in path to filemd5
#   content_type = lookup({
#     "html" = "text/html",
#     "css"  = "text/css",
#     "js"   = "application/javascript",
#     "json" = "application/json",
#     "png"  = "image/png",
#     "jpg"  = "image/jpeg",
#     "jpeg" = "image/jpeg",
#     "gif"  = "image/gif",
#     "svg"  = "image/svg+xml",
#     "ico"  = "image/x-icon",
#     "txt"  = "text/plain"
#   }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
# }


# #cloud front distribution
# resource "aws_cloudfront_distribution" "s3_distribution" {
#   origin {
#     domain_name = aws_s3_bucket.firstbucket.bucket_regional_domain_name
#     origin_id   = local.origin_id
#     origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
#   }

#   enabled             = true
#   is_ipv6_enabled     = true
#   comment             = "Some comment"
#   default_root_object = "index.html"

#   # logging_config {
#   #   include_cookies = false
#   #   bucket          = "mylogs.s3.amazonaws.com"
#   #   prefix          = "myprefix"
#   # }


#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = local.origin_id

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }

#   price_class = "PriceClass_100"

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   tags = {
#     Environment = "production"
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }
variable "item" {
  default = ["apple", "banana", "mango"]
}

output "upper_items" {
  value = [for s in var.item : upper(s)]
}

output "even_numbers" {
  value = [for n in [1,2,3,4,5] : n if n % 2 == 0]
}
