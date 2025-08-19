terraform {
  backend "s3" {
    bucket       = "towfique-terraform-state"
    key          = "infra/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
