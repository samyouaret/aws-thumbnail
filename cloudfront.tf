resource "aws_cloudfront_origin_request_policy" "forward_resize_params" {
  name    = "forward_resize_params"
  comment = "forward resize params to origin"
  query_strings_config {
    query_string_behavior = "whitelist"
    query_strings {
      items = ["w", "h"]
    }
  }

  headers_config {
    header_behavior = "none"
  }

  cookies_config {
    cookie_behavior = "none"
  }
}

data "aws_cloudfront_cache_policy" "CachingOptimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "lambda_distribution" {
  origin {
    domain_name = "${aws_lambda_function_url.lambda_url.url_id}.lambda-url.us-east-1.on.aws"
    origin_id   = "${aws_lambda_function_url.lambda_url.url_id}.lambda-url.us-east-1.on.aws"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

  }

  depends_on = [
    aws_cloudfront_origin_request_policy.forward_resize_params,
    aws_lambda_function_url.lambda_url
  ]

  enabled = true

  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "${aws_lambda_function_url.lambda_url.url_id}.lambda-url.us-east-1.on.aws"
    viewer_protocol_policy   = "allow-all"
    min_ttl                  = 0
    default_ttl              = 3600
    max_ttl                  = 86400
    cache_policy_id          = data.aws_cloudfront_cache_policy.CachingOptimized.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.forward_resize_params.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      # locations        = ["US", "CA", "GB", "DE"]
      locations = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
