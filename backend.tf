## Auto generated backend.tf ##
## Updated on: 2023-12-15 15:16:17 ##

terraform {
  required_version = ">= 0.15.1"
  backend "s3" {
    region = "us-east-1"
    bucket = "training-760886765969-terraform-state"
    key    = "760886765969-training-tfc/terraform.tfstate"
  }
}