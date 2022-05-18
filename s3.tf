provider "aws" {
  alias = "noregion"
  endpoints {
    s3 = "https://storage.cloud.croc.ru"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  insecure   = false
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
}

resource "aws_s3_bucket" "website_s3_test" {
  provider = aws.noregion
  bucket = "website_s3_test"
  acl = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = <<RULES
[{
   "Condition": {
       "HttpErrorCodeReturnedEquals": "404"
   },
   "Redirect": {
       "HostName": "search.nyansq.ru",
       "HttpRedirectCode": "301",
       "Protocol": "https"
   }
}]
RULES
  }
}
