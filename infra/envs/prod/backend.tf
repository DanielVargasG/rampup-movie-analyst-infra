terraform {
  backend "s3" {
    bucket       = "epam-final-tfstate-588622053316"
    key          = "prod/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }

  required_version = ">= 1.11"
}