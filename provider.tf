variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "croc"
}

terraform {
  required_providers {
    aws        = {
      source  = "hc-registry.website.cloud.croc.ru/c2devel/croccloud"
      version = "4.14.0-CROC1"
    }
    kubernetes = {
      source  = "hc-registry.website.cloud.croc.ru/hashicorp/kubernetes"
      version = "2.11.0"
    }
    random     = {
      source  = "hc-registry.website.cloud.croc.ru/hashicorp/random"
      version = "3.3.2"
    }
    tls        = {
      source  = "hc-registry.website.cloud.croc.ru/hashicorp/tls"
      version = "3.1.0"
    }
    template    = {
      source  = "hc-registry.website.cloud.croc.ru/hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "aws" {
  endpoints {
    ec2 = "https://api.cloud.croc.ru"
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
