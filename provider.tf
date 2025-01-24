terraform {
  required_providers {
    aws        = {
      source  = "hc-registry.website.k2.cloud/c2devel/rockitcloud"
      version = "24.1.0"
    }
  }
}

provider "aws" {
  endpoints {
    ec2 = "https://ec2.k2.cloud"
    elbv2 = "https://elb.k2.cloud"
  }

  # NOTE: STS API is not implemented, skip validation
  skip_credentials_validation = true

  # NOTE: IAM API is not implemented, skip validation
  skip_requesting_account_id = true

  # NOTE: Region has different name, skip validation
  skip_region_validation = true

  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}
