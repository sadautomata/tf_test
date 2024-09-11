variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "croc"
}

terraform {
  required_providers {
    aws        = {
      source  = "tf-registry.nyansq.ru/c2devel/rockitcloud"
      version = "24.1.0"
    }
    local = {
        source  = "tf-registry.nyansq.ru/opentofu/local"
        version = "2.5.1"
    }
    ct = {
        source  = "tf-registry.nyansq.ru/poseidon/ct"
        version = "0.13.0"
    }
  }
#  backend "s3" {
#    bucket                      = "pena54"
#    key                         = "terraform.tfstate"
#    region                      = "us-east-1"
#    endpoint                    = "https://s3.k2.cloud"
#    skip_credentials_validation = true
#    skip_region_validation      = true
#    skip_metadata_api_check     = true
#  }
}

provider "aws" {
  endpoints {
    ec2 = "https://ec2.k2.cloud"
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
    s3 = "https://s3.k2.cloud"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  insecure   = false
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
}
